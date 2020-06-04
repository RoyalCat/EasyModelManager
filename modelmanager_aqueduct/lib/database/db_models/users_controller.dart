// ignore_for_file: implicit_dynamic_map_literal
import 'dart:async';
import "dart:convert";
import "dart:io";

import "package:meta/meta.dart";

import "package:shared_models/user_model.dart";

const _minConfig = "[]";

class UsersController
{
  static const JsonCodec _jsonCodec = JsonCodec();
  Map<String, UserModel> nameUserMap = Map<String, UserModel>();
  File configFile;

  UsersController({
    @required Directory folderPath,
  })
  {
    configFile = File("${folderPath.path}/user_database.json");
    if(!configFile.existsSync())
    {
      configFile.createSync();
      configFile.writeAsStringSync(_minConfig);
    }
    _readConfig();
  }

  void _readConfig()
  {
    final dynamic json = _jsonCodec.decode(configFile.readAsStringSync());
    for(final confgJson in json)
    {
      final UserModel user = UserModel.fromJson(confgJson as Map<String, dynamic>);
      nameUserMap[user.name] = user;
    }
  }

  void _writeConfig()
  {
    final List<Map<String, dynamic>> json = List<Map<String, dynamic>>();
    for(var user in nameUserMap.values)
    {
      json.add(user.toJson());
    }
    configFile.writeAsStringSync(_jsonCodec.encode(json));
  }

  Future save() async
  {
    _writeConfig();
  }
  
  UserModel operator [](String key) => nameUserMap[key];
  void operator []=(String key, UserModel value) => nameUserMap[key] = value;

  void add(UserModel user)
  {
    nameUserMap[user.name] = user;
  }

  List<UserModel> getUsersList()
  {
    return nameUserMap.values?.toList();
  }
}