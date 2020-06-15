import 'dart:async';
import "dart:io";
import "package:meta/meta.dart";
import 'package:shared_models/model_config.dart';

import "./db_models/model_config_controller.dart";


class ModelsDatabase {
  final Directory modelsDirectory;
  static ModelsConfigController _modelsConfig;

  ModelsDatabase({
    @required this.modelsDirectory,
  }) {
    if (!modelsDirectory.existsSync()) {
      modelsDirectory.createSync(recursive: true);
    }
    _modelsConfig = ModelsConfigController(folderPath: modelsDirectory);
  }

  void save() => _modelsConfig.save();

  Future<void> addModel(ModelConfig config) async
  {
    config.versions ??= List<String>();
    final modelDir = Directory("${modelsDirectory.path}/${config.name}");
    if(!modelDir.existsSync()) {
      modelDir.createSync();
      _modelsConfig.add(config);
    }
    else
    {
      throw 208;
    }
    
  }

  Future<void> addVersion(ModelConfig model, String version, Stream<List<int>> fileStream) async
  {
    final modelFile = File('${modelsDirectory.path}/${model.name}/$version');
    if(!modelFile.existsSync())
    {
      modelFile.createSync();
    }
    fileStream.listen(modelFile.writeAsBytesSync);
  }

  IOSink newVersionSink(ModelConfig model, String version)
  {
    return File("${modelsDirectory.path}/${model.name}/$version").openWrite();
  }

  List<ModelConfig> getModels() => _modelsConfig.getConfigList();
  ModelConfig queryName(String name) => _modelsConfig[name];

  bool remove(String name)
  {
    _modelsConfig.configs.remove(name);
    final modelDir = Directory("${modelsDirectory.path}/${name}");
    if(!modelDir.existsSync()) {
      modelDir.delete(recursive: true);
    }
  }


  int get size
  {
    int summarySize = 0;
    for(final model in _modelsConfig.configs.values)
    {
      summarySize += model.size;
    }
    return summarySize;
  }
}