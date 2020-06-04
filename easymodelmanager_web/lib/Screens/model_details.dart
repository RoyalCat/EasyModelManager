import 'package:flutter/material.dart';
import 'package:shared_models/model_config.dart';

class ModelDetails extends StatefulWidget {
  final ModelConfig modelConfig;

  ModelDetails({
    Key key,
    @required 
    this.modelConfig,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
  Widget _versionItem(String version) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        padding: EdgeInsets.all(8),
        height: 50,
        child: Row(
          children: [
            Text('Version: ${version}'),
            Spacer(),
            RaisedButton(
              child: Icon(Icons.file_download),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelConfig.name),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 80,
              margin: EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest version: ${widget.modelConfig.versions.last}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'Last update: ${widget.modelConfig.lastChange}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          RaisedButton(
                            child: Row(
                              children: [
                                Text('Download latest version'),
                                SizedBox(width: 10),
                                Icon(Icons.file_download),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: widget.modelConfig.versions.length,
                  itemExtent: 50,
                  itemBuilder: (context, i) => _versionItem(widget.modelConfig.versions[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
