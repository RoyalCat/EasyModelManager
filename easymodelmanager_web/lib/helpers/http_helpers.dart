import 'dart:convert';

import 'package:easymodelmanager_web/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<http.Response> sendAuthorisedGet(
  String path,
  Map<String, String> userInformation,
  AppConfig config,
) async {
  final String passMd5 = generateMd5(userInformation['pass']);
  final String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(
          '${userInformation['login']}:${passMd5}'));
  final response = await http.get(
    '${config.apiUrl}$path',
    headers: {
      'authorization': basicAuth,
    },
  );

  return response;
}

Future<http.Response> sendAuthorisedPost(
  String path,
  dynamic body,
  Map<String, String> userInformation,
  AppConfig config,
) async {
  String passMd5 = generateMd5(userInformation['pass']);
  String basicAuth = 'Basic ' +
      base64Encode(utf8.encode(
          '${userInformation['login']}:${passMd5}'));
  final response = await http.post(
    '${config.apiUrl}$path',
    body: body,
    headers: {
      'authorization': basicAuth,
    },
  );

  return response;
}