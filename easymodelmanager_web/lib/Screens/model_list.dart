import 'dart:async';

import 'package:easymodelmanager_web/Screens/model_list_item.dart';
import 'package:easymodelmanager_web/Screens/uploadmodel.dart';
import 'package:easymodelmanager_web/helpers/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/model_config.dart';
import 'package:shared_models/user_model.dart';

//igonre_for_file: implicit_dynamic_map_literal

class ModelsListScreen extends StatefulWidget {
  final UserModel user;

  ModelsListScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _ModelsListScreen createState() => _ModelsListScreen();
}

class _ModelsListScreen extends State<ModelsListScreen> {
  List<ModelConfig> models = List<ModelConfig>();
  Map<String, ModelConfig> modelsMap = Map<String, ModelConfig>();

  ApiHandler api;

  Future<void> updateModelList() async {
    List<ModelConfig> _models = await api.getModelsList();
    modelsMap = toMapByName(_models);
    setState(() {
      models = modelsMap.values.toList();
    });
  }

  Future<void> setSearchFilter(String filter) async {
    models.clear();
    setState(() {
      modelsMap.keys.where((element) {
        return element.startsWith(filter);
      }).forEach((modelName) {
        models.add(modelsMap[modelName]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      api = Provider.of<ApiHandler>(context, listen: false);
      updateModelList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (models.isNotEmpty)
        ? Container(
            child: ListView.builder(
              itemCount: models.length + 1,
              itemExtent: 150,
              itemBuilder: (context, i) => (i == 0)
                  ? UploadModelScreen(onNewModel: updateModelList,)
                  : ModelListItem(modelConfig: models[i - 1]),
            ),
          )
        : Center(
            child: const CircularProgressIndicator(),
          );
  }
}
