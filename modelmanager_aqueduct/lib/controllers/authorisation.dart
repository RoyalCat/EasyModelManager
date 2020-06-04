import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:shared_models/user_model.dart';

import '../database/database.dart';

class SignupController extends ResourceController {
  final Database database;

  SignupController(this.database);

  @Operation.post()
  Future<Response> signup() async {

    // get user info from request body
    final map = await request.body.decode<Map<String, String>>();
    final UserModel user = UserModel.fromJson(map);

    final UserModel foundUser = database.queryName(user.name);
    if (foundUser != null) {
      return Response.forbidden();
    }

    // add user to database
    await database.addUser(user);

    // send a response 
    return Response.ok('user added');
  }
}

class LoginController extends ResourceController {
  @Operation.get()
  Future<Response> login() async
  {
    return Response.ok('');
  }
}