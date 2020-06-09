import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_models/user_model.dart';

import '../database/database.dart';
import 'controller.dart';

class RestrictedController extends Controller {
  final Database database;
  final bool isAdminOnly;
  RestrictedController(this.database, {
    this.isAdminOnly = false
  });

  @override
  Future<bool> get(HttpRequest request) {
      return authorise(request);
    }
  
  @override
  Future<bool>post(HttpRequest request) {
    return authorise(request);
  }


  Future<bool> authorise(HttpRequest request) async
  {
    if (_isAuthorized(request.headers['authorization']?.join(' '))) {
      return true;
    }

    request.response.statusCode = 401;
    return false;
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

    if(isAdminOnly && foundUser.userType == 'admin')
    {
      return foundUser != null && foundUser.password == user.password;
    }
    else
    {
      return foundUser != null && foundUser.password == user.password;
    }

    
  }
}
