import 'dart:async';
import 'dart:convert';
import 'package:aqueduct/aqueduct.dart';
import '../database/database.dart';
import 'package:shared_models/user_model.dart';

class RestrictedController extends Controller {
  final Database database;
  RestrictedController(this.database);

  @override
  Future<RequestOrResponse> handle(Request request) async {
    if (_isAuthorized(request.raw.headers['authorization']?.join(' '))) {
      return request;
    }

    return Response.unauthorized();
  }


  bool _isAuthorized(String authHeader) {
    final parts = authHeader?.split(' ');
    if (parts == null || parts.length != 2 || parts[0] != 'Basic') {
      return false;
    }
    return _isValidUsernameAndPassword(parts[1]);
  }

  // check username and password
  bool _isValidUsernameAndPassword(String credentials) {
    // this user
    final String decoded = utf8.decode(base64.decode(credentials));
    final parts = decoded.split(':');
    final UserModel user = UserModel(parts[0], parts[1]);

    final UserModel foundUser = database.queryName(user.name);

    // check for match
    return foundUser != null && foundUser.password == user.password;
  }
}
