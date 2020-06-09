import 'dart:io';

import 'controllers/controller.dart';

class Router {
  Map<Uri, List<Controller>> handlers = {};

  void route(String url, List<Controller> controllers) {
    handlers[Uri.parse(url)] = controllers;
  }

  void handle(HttpRequest request) async {
    print(request.uri);
    try {
      request.response.headers.add("Access-Control-Allow-Origin", "*");
      request.response.headers.add("Access-Control-Allow-Headers", "*");

      bool pass = true;
      for (final controller in handlers[request.uri]) {
        if (pass) {
          switch (request.method) {
            case "GET":
              pass = await controller.get(request);
              break;
            case "POST":
              pass = await controller.post(request);
              break;
            case "OPTIONS":
              request.response.statusCode = 200;
              break;
            default:
              throw UnimplementedError();
          }
        }
      }
    } on UnimplementedError {
      request.response.statusCode = 501;
    } on NoSuchMethodError {
      request.response.statusCode = 501;
    } catch (e) {
      request.response.statusCode = (e is int) ? e : 500;
    } finally {
      await request.response.close();
    }
    
  }
}
