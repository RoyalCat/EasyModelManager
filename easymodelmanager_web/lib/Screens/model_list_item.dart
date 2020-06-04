import 'package:easymodelmanager_web/Screens/model_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/model_config.dart';
import 'package:theme_provider/theme_provider.dart';

class ModelListItem extends StatefulWidget
{
  final ModelConfig modelConfig;

  ModelListItem({
    Key key,
    @required
    this.modelConfig
  }) : super(key: key);

  @override
  _ModelListItemState createState() => _ModelListItemState();
}

class _ModelListItemState extends State<ModelListItem>
{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.modelConfig.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'latest version: ${widget.modelConfig.versions.last}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      'last update ${widget.modelConfig.lastChange}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    RaisedButton(
                      child: Text('Open more details'),
                      onPressed: () {
                        Navigator.of(context).push(
                           MaterialPageRoute<ModelDetails>(
                             builder: (contex) {
                               return ThemeConsumer(child: ModelDetails(modelConfig: widget.modelConfig,));
                             },
                           ),
                         );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Spacer(),
                    RaisedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.file_download,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
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
                    child: Text(widget.modelConfig.description),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
