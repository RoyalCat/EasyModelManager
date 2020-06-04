import 'dart:convert';
import 'package:flutter/services.dart';


class AppConfig {
  final String apiUrl;
  
  AppConfig({this.apiUrl});

  static Future<AppConfig> forEnvironment({String env = 'dev'}) async {

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(apiUrl: json['apiUrl'] as String);
  }
}