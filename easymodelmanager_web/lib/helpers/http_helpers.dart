import 'dart:convert';

import 'package:easymodelmanager_web/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Map<String, String> _generateAuthHeader(Map<String, String> userInformation) {
  final String passMd5 = generateMd5(userInformation['pass']);
  final String logpass = '${userInformation['login']}:${passMd5}';
  return {'authorization': 'Basic ' + base64Encode(utf8.encode(logpass))};
}

Future<http.Response> sendAuthorisedGet(
  String path,
  Map<String, String> userInformation,
  AppConfig config,
) async {
  final response = await http.get(
    '${config.apiUrl}$path',
    headers: _generateAuthHeader(userInformation),
  );

  return response;
}

Future<http.Response> sendAuthorisedPost(
  String path,
  dynamic body,
  Map<String, String> userInformation,
  AppConfig config,
) async {
  final response = await http.post(
    '${config.apiUrl}$path',
    body: body,
    headers: _generateAuthHeader(userInformation),
  );

  return response;
}

Future<http.Response> uploadFile(
  String path,
  Map<String, String> userInformation,
  AppConfig config,
  http.MultipartFile file,
  String filename, {
  Map<String, String> headers,
}) async {
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '${config.apiUrl}$path',
      ));
  request.files.add(file);
  request.headers.addAll(_generateAuthHeader(userInformation));
  request.headers.addAll({
    'model-name': 'Model1',
    'version': '100',
  });
  final response = await request.send();
  return http.Response.fromStream(response);
}
