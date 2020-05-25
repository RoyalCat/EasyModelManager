import 'dart:async';

import "package:easymodelmanager_web/Screens/model_list_item.dart";
import "package:flutter/material.dart";
import "package:shared_models/model_config.dart";

//igonre_for_file: implicit_dynamic_map_literal

class ModelsListScreen extends StatefulWidget {
  final String userKey;

  ModelsListScreen({
    Key key,
    this.userKey,
  }) : super(key: key);

  @override
  _ModelsListScreen createState() => _ModelsListScreen();
}

class _ModelsListScreen extends State<ModelsListScreen> {

  List<ModelConfig> models = List<ModelConfig>();

  
  Future updateModelList(String key) async
  {
    models.add(
      ModelConfig.fromJson(
        {
          "name": "Model1",
          "versions": ["0.0.1","0.0.2","0.0.3"],
          "lastChange": DateTime.now(),
          "description": "",
          "size": 100
        }
      )
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {updateModelList(""); });
  }

  @override
  Widget build(BuildContext context) {
    return (models.isNotEmpty) ? Container(
      child: ListView.builder(
        itemCount: models.length,
        itemExtent: 150,
        itemBuilder: (context, i) => ModelListItem(modelConfig: models[i]),
      ),
    ) : Center(
      child: const CircularProgressIndicator(),
    );
  }
}