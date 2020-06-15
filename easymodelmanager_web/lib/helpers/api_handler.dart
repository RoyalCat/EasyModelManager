import 'dart:convert';

import 'package:easymodelmanager_web/app_config.dart';
import 'package:easymodelmanager_web/helpers/http_helpers.dart';
import 'dart:async';

import 'package:shared_models/user_model.dart';

class ApiHandler {
  AppConfig config;
  Map<String, String> userParameters;

  ApiHandler(
    this.config, {
    String login,
    String password,
  }) {
    userParameters = {
      'login': login,
      'pass': password,
    };
  }

  void setUserParams(String login, String password) {
    userParameters = {
      'login': login,
      'pass': password,
    };
  }

  Future<bool> signUp() async {
    final body = jsonEncode({
      'name': userParameters['login'],
      'password': generateMd5(userParameters['pass']),
    });
    final response =
        await sendAuthorisedPost('/signup', body, userParameters, config);
    return response?.statusCode == 200;
  }

  Future<UserModel> login({bool adminCheck = false}) async {
    final response = await sendAuthorisedGet(
        adminCheck ? '/admin/login' : '/login', userParameters, config);
    return (response?.statusCode == 200)
        ? UserModel(userParameters['login'], userParameters['pass'])
        : null;
  }

  Future<String> getStatistic() async {
    final response =
        await sendAuthorisedGet('/admin/get_statistic', userParameters, config);
    return (response?.statusCode == 200) ? response.body : null;
  }

  Future<List<UserModel>> getUsers() async {
    final response =
        await sendAuthorisedGet('/admin/get_users', userParameters, config);
    if (response?.statusCode == 200) {
      final List<UserModel> users = [];
      final usersJson = jsonDecode(response.body) as List<dynamic>;
      for(final userJson in usersJson)
      {
        users.add(UserModel.fromJson(userJson as Map<String, dynamic>));
      }
      return users;
    } else {
      return null;
    }
  }
}
