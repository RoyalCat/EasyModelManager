import 'dart:async';
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:shared_models/user_model.dart';

import '../database/database.dart';
import '../utils.dart';
import 'controller.dart';


class ModelUploadController extends Controller
{
  Database database;

  ModelUploadController(this.database);

  @override
  Future<bool> post(HttpRequest request) async {
    final UserModel user = getUserFromHeader(request.headers, database);
    final String modelName = request.headers['model-name'][0];
    final String version = request.headers['version'][0];
    final boundary = request.headers.contentType.parameters["boundary"];
    final transformer = MimeMultipartTransformer(boundary);

    final parts = await transformer.bind(request).toList();

   for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      final content = multipart.cast<List<int>>();

      final sink = database.newVersionSink(user, modelName, version);
      await content.forEach(sink.add);
      await sink.flush();
      await sink.close();
    }

    request.response.statusCode = 200;
    return false;
  }

  @override
  Future<bool> get(HttpRequest request) {
    throw UnimplementedError();
  }
}