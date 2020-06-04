import 'package:modelmanager_aqueduct/database/db_models/users_controller.dart';

import 'package:modelmanager_aqueduct/modelmanager_aqueduct.dart';
import "package:meta/meta.dart";
import 'package:uuid/uuid.dart';
import 'package:shared_models/user_model.dart';
import "models_database.dart";

class Database {
  final _uuidGenerator = Uuid();

  Directory databaseDirectory;
  UsersController usersController;
  Map<String, ModelsDatabase> userDataDatabase = Map<String, ModelsDatabase>();

  Database({
    @required this.databaseDirectory,
  }) {
    if (!databaseDirectory.existsSync()) {
      databaseDirectory.createSync(recursive: true);
    }
    usersController = UsersController(
      folderPath: databaseDirectory,
    );

    for (final user in usersController.nameUserMap.values) {
      final models = ModelsDatabase(
        modelsDirectory: Directory("${databaseDirectory.path}/${user.id}"),
      );

      userDataDatabase[user.id.toString()] = models;
    }
  }

  void saveUsers() => usersController.save();
  void saveUserData(UserModel userModel) => userDataDatabase[userModel.id].save();
  void saveAllUsersData() => userDataDatabase.values.forEach((value) => value.save());

  Future addUser(UserModel user) async {
    user.id ??= _uuidGenerator.v4();
    user.userType ??= "user";
    usersController.add(user);
    userDataDatabase[user.id.toString()] = ModelsDatabase(
      modelsDirectory: Directory("${databaseDirectory.path}/${user.id}"),
    );
    saveUsers();
  }

  UserModel queryName(String name) => usersController[name];
}
