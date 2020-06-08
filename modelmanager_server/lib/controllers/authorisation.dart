import 'dart:async';
import 'dart:convert' show Utf8Decoder, jsonDecode;
import 'dart:io';

import 'package:shared_models/user_model.dart';

import '../database/database.dart';
import './controller.dart';


class SignupController extends Controller {
  final Database database;

  SignupController(this.database);

  @override
  Future<bool> post(HttpRequest request) async {
    const decoder = Utf8Decoder();
    final String body = await decoder.bind(request).join();

    // get user info from request body
    final map = jsonDecode(body);
    final UserModel user = UserModel.fromJson(map as Map<String, dynamic>);

    final UserModel foundUser = database.queryName(user.name);
    if (foundUser != null) {
      request.response.statusCode = 409;
      return false;
    }

    // add user to database
    await database.addUser(user);
    request.response.write("user added");
    return false;
  }

  @override
  Future<bool> get(HttpRequest request) {
    throw UnimplementedError();
  }
}

class LoginController extends Controller {
  @override
  Future<bool> get(HttpRequest request) async
  {
    request.response.statusCode = 200;
    return false;
  }

  @override
  Future<bool> post(HttpRequest request) {
    throw UnimplementedError();
  }
}