// ignore_for_file: implicit_dynamic_map_literal
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

  Future addModel(ModelConfig config) async
  {
    _modelsConfig.add(config);
  }
}
