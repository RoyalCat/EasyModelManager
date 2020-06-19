// ignore_for_file: implicit_dynamic_map_literal
import 'dart:async';
import "dart:convert";
import "dart:io";

import "package:meta/meta.dart";
import "package:shared_models/model_config.dart";

const _minConfig = "[]";

class ModelsConfigController
{
  static const JsonCodec _jsonCodec = JsonCodec();
  Map<String, ModelConfig> configs = Map<String, ModelConfig>();
  File configFile;
  final String id;

  ModelsConfigController({
    @required Directory folderPath,
    @required this.id
  })
  {
    configFile = File("${folderPath.path}/models_config.json");
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
    for(final confgJson in  json)
    {
      final ModelConfig config = ModelConfig.fromJson(confgJson as Map<String, dynamic>);
      configs[config.name] = config;
    }
  }

  void _writeConfig()
  {
    final List<Map<String, dynamic>> json = [];
    for(var config in configs.values)
    {
      json.add(config.toJson());
    }
    configFile.writeAsStringSync(_jsonCodec.encode(json));
  }

  Future<void> save() async
  {
    return _writeConfig();
  }
  
  ModelConfig operator [](String name) => configs[name];
  void operator []=(String name, ModelConfig value) => configs[name] = value;

  void add(ModelConfig config)
  {
    configs[config.name] = config;
    save();
  }

  List<ModelConfig> getConfigList()
  {
    return configs.values.toList();
  }
}