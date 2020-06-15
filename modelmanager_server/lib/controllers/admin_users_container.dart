import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:modelmanager_server/database/database.dart';
import 'package:shared_models/model_config.dart';
import 'package:shared_models/user_model.dart';

import 'controller.dart';

class UserListController extends Controller
{
  final Database database;

  UserListController(this.database);

  @override
  Future<bool> get(HttpRequest request) async {
    final body = jsonEncode(database.getAllUsers());
    request.response.write(body);
    return false;
  }

}

class UserDataController extends Controller
{
  final Database database;

  UserDataController(this.database);

  @override
  Future<bool> get(HttpRequest request) async {
    if(request.headers['username'] != null)
    {
      final String username = request.headers['username'][0];
      final UserModel user = database.queryName(username);
      final List<ModelConfig> models = database.getModelsByUser(user).getModels();
      request.response.write(jsonEncode(models));
    } else {
      throw 400;
    }
    return false;
  }
}

class UserDeleteController extends Controller
{
  final Database database;

  UserDeleteController(this.database);

  @override
  Future<bool> post(HttpRequest request) async {
    final String id = request.headers['id'][0];
    database.remove(id);
    
    return false;
 }
}

class UserModelDeleteController extends Controller
{
  final Database database;

  UserModelDeleteController(this.database);

  @override
  Future<bool> post(HttpRequest request) async {
    final String id = request.headers['id'][0];
    final String modelname = request.headers['modelname'][0];
    database.userDataDatabase[id].remove(modelname);
    
    return false;
 }
}