import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_models/user_model.dart';

import 'database/database.dart';

const decoder = Utf8Decoder();

UserModel getUserFromHeader(HttpHeaders headers, Database database)
{
  final credentials = headers[HttpHeaders.authorizationHeader][0].split(' ')[1];
  final String decoded = utf8.decode(base64.decode(credentials));
  return database.queryName(decoded.split(':')[0]);
}

Future<String> getBody(HttpRequest request) async => decoder.bind(request).join();