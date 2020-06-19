import 'dart:async';
import 'dart:html';

import 'package:easymodelmanager_web/helpers/api_handler.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadModelScreen extends StatefulWidget {
  void Function() onNewModel;

  UploadModelScreen({
    Key key,
    @required this.onNewModel,
  }) : super(key: key);

  @override
  _UploadModelScreen createState() => _UploadModelScreen();
}

class _UploadModelScreen extends State<UploadModelScreen> {
  bool active = false;
  FilePickerCross filePicker = FilePickerCross();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  ApiHandler api;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      api = Provider.of<ApiHandler>(context, listen: false);
    });
  }

  void _createModel() {
    api
        .newModel(_nameController.text, _descriptionController.text)
        .then((_) => widget.onNewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      height: 150,
      margin: EdgeInsets.all(8),
      child: active
          ? Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    Text('Name:'),
                                    Expanded(
                                      child: TextField(
                                        controller: _nameController,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text('Create'),
                                onPressed: _createModel,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 15,
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Description'),
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            controller: _descriptionController,
                            expands: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          : GestureDetector(
              onTap: () => setState(() {
                    active = !active;
                  }),
              child: Icon(Icons.add, size: 80)),
    );
  }
}
