import 'dart:async';

import 'package:easymodelmanager_web/helpers/api_handler.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filesize/filesize.dart';

class UploadVersionScreen extends StatefulWidget {
  final String modelName;
  UploadVersionScreen({
    Key key,
    @required this.modelName
  }) : super(key: key);

  @override
  _UploadVersionScreen createState() => _UploadVersionScreen();
}


class _UploadVersionScreen extends State<UploadVersionScreen> {
  bool active = false;
  bool picked = false;
  final TextEditingController versionController = TextEditingController();
  final FilePickerCross filePicker = FilePickerCross();
  ApiHandler api;

  @override
  void initState() { 
    super.initState();
    Timer.run((){ 
      api = Provider.of<ApiHandler>(context, listen: false);
    });
  } 

  void _pickFile()
  {
    filePicker.pick().then((value) => setState((){
      picked = true;
    }));
  }

  void _uploadPickedFile()
  {
    api.uploadVersion(filePicker.toMultipartFile(), widget.modelName, versionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      margin: EdgeInsets.all(8),
      child: active
          ? Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Text('Version:'),
                Expanded(
                  flex: 2,
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 1,
                  child: Text('Size: ${picked ? filesize(filePicker.length) : ""}'),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  child: RaisedButton(
                    child: Text('Select file'),
                    onPressed: _pickFile,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  child: Icon(Icons.file_upload),
                  onPressed: picked ? _uploadPickedFile : null,
                ),
              ],
            ),
          )
          : GestureDetector(
              onTap: () => setState(() {
                    active = true;
                  }),
              child: Icon(Icons.add)),
    );
  }
}