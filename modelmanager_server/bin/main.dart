import 'dart:async';
import 'dart:io';

import 'package:modelmanager_server/channel.dart';

final String _host = InternetAddress.loopbackIPv4.host;

Future<void> main() async {
  final channel = ModelManagerChannel();
  
  final server = await HttpServer.bind(_host, 4049);

  server.listen(channel.handle);

  print("Application started on port: ${server.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");

}