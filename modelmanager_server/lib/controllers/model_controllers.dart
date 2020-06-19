
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_models/model_config.dart';
import 'package:shared_models/user_model.dart';

import '../database/database.dart';
import '../database/models_database.dart';
import '../utils.dart';
import 'controller.dart';

class ModelsListController extends Controller
{
  final Database database;

  ModelsListController(this.database);

  @override
  Future<bool> get(HttpRequest request) async
  {
    final credentials = request.headers[HttpHeaders.authorizationHeader][0].split(' ')[1];
    final String decoded = utf8.decode(base64.decode(credentials));
    final UserModel user = database.queryName(decoded.split(':')[0]);
    final ModelsDatabase modelsDatabase = database.getModelsByUser(user);
    final List<ModelConfig> models = modelsDatabase.getModels();
    request.response.statusCode = 200;
    request.response.write(jsonEncode(models));
    
    return false;
  }

  @override
  Future<bool> post(HttpRequest request) {
    throw UnimplementedError();
  }
}

class AddNewModelController extends Controller
{
  final Database database;

  AddNewModelController(this.database);

  @override
  Future<bool> post(HttpRequest request) async
  {
    final UserModel user = getUserFromHeader(request.headers, database);
    final ModelsDatabase modelsDatabase = database.getModelsByUser(user);
    final String body = await getBody(request);
    final ModelConfig modelConfig = ModelConfig.fromJson(jsonDecode(body) as Map<String, dynamic>);
    if(modelConfig.isValid)
    {
      await modelsDatabase.addModel(modelConfig);
      request.response.statusCode = 200;
    } else {
      request.response.statusCode = 400;
    }
    
    return false;
  }

  @override
  Future<bool> get(HttpRequest request) {
    throw UnimplementedError();
  }
}