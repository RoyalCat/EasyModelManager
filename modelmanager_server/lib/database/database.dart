import 'dart:async';
import 'dart:collection';
import 'dart:io';


import "package:meta/meta.dart";
import 'package:shared_models/model_config.dart';
import 'package:shared_models/user_model.dart';
import 'package:uuid/uuid.dart';

import 'db_models/users_controller.dart';
import "models_database.dart";

class Database {
  final _uuidGenerator = Uuid();

  Directory databaseDirectory;
  UsersController usersController;
  HashMap<String, ModelsDatabase> userDataDatabase = HashMap<String, ModelsDatabase>();

  Database({
    @required this.databaseDirectory,
  }) {
    if (!databaseDirectory.existsSync()) {
      databaseDirectory.createSync(recursive: true);
    }
    usersController = UsersController(
      folderPath: databaseDirectory,
    );

    for (final user in usersController.users) {
      userDataDatabase[user.id] = ModelsDatabase(
        id: user.id,
        modelsDirectory: Directory("${databaseDirectory.path}/${user.id}"),
      );
    }
  }

  void saveUsers() => usersController.save();
  void saveUserData(UserModel userModel) => userDataDatabase[userModel.id].save();
  void saveAllUsersData() => userDataDatabase.values.forEach((value) => value.save());

  Future addUser(UserModel user) async {
    user.id ??= _uuidGenerator.v4();
    user.userType ??= "user";
    usersController.add(user);
    userDataDatabase[user.id] = ModelsDatabase(
      id: user.id,
      modelsDirectory: Directory("${databaseDirectory.path}/${user.id}"),
    );
    saveUsers();
  }

  Future<void> addModel(UserModel user, ModelConfig model) async
  {
    final userModels = getModelsByUser(user);
    await userModels.addModel(model);
    userModels.save();
  } 

  Future<void> addVersion(UserModel user, String modelName, String version, Stream<List<int>> fileStream) async {
    final modelConfig = getModelsByUser(user).queryName(modelName);
    await userDataDatabase[user.id].addVersion(modelConfig, version, fileStream);
  }

  IOSink newVersionSink(UserModel user, String modelName, String version)
  {
    final modelConfig = getModelsByUser(user).queryName(modelName);
    return userDataDatabase[user.id].newVersionSink(modelConfig, version);
  }

  UserModel queryName(String name) {
    for (var user in usersController.users)
    {
      if(user.name == name)
      {
        return user;
      }
    }
    return null;
  }
  
  ModelsDatabase getModelsByUser(UserModel user) => userDataDatabase[user.id];

  int getSummaryDataSize()
  {
    int summarySize = 0;
    for (final userdata in userDataDatabase.values)
    {
      summarySize += userdata.size;
    }
    return summarySize;
  }

  void remove(String id)
  {
    userDataDatabase.remove(id);
    usersController.remove(id);
  }

  List<UserModel> getAllUsers() => usersController.users.toList();
}
