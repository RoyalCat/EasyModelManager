import 'dart:async';

import 'package:flutter/material.dart';
import "package:theme_provider/theme_provider.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [AppTheme.light(), AppTheme.dark()],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: MaterialApp(
        title: "ModelManager",
        home: ThemeConsumer(child: MyHomePage(title: 'Easy Model Manager')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future _displayDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter login token"),
          content: TextField(
            controller: null,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _loggined = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void openModelDetails() {}

  Widget _getListItem(String name) {
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
                      name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "latest version:",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "last update",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    RaisedButton(
                      child: Text("Open more details"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (contex) {
                              return ModelDetails();
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
                  Text("Description"),
                  Expanded(
                    child: Text(
                      "ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora ora",
                      maxLines: null,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _newListItem(bool active) {
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
                                    Text("Name:"),
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    Text("Version:"),
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 100,
                              child: RaisedButton(
                                child: Text("Select file"),
                                onPressed: () {},
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("File name:"),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("Size:"),
                            ),
                          ],
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
                        Text("Description"),
                        Expanded(
                          child: TextField(
                            maxLines: null,
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
          : Icon(Icons.add, size: 80),
    );
  }

  bool _darkTheme = false;
  bool _loggined = false;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      if (ThemeProvider.themeOf(context).id == AppTheme.dark().id) {
        setState(() {
          _darkTheme = true;
        });
      }
    });
    Timer.run(() => _displayDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 35,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Spacer(),
                  Switch(
                    value: _darkTheme,
                    onChanged: (value) {
                      _darkTheme = value;
                      ThemeProvider.controllerOf(context).nextTheme();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: _loggined
            ? ListView(
                itemExtent: 150,
                padding: EdgeInsets.all(8),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  _newListItem(false),
                  _getListItem("Model1"),
                  _getListItem("Model2"),
                  _getListItem("Model3"),
                  _getListItem("Model4"),
                  _getListItem("Model5"),
                  _getListItem("Model6"),
                  _getListItem("Model7"),
                  _getListItem("Model8"),
                ],
              )
            : Container(),
      ),
    );
  }
}

class ModelDetails extends StatefulWidget {
  ModelDetails({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
  Widget _versionItem(String version, DateTime dateTime) {
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
            Text("Version: $version"),
            Spacer(
              flex: 6,
            ),
            Text("Date: ${dateTime.toIso8601String()}"),
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
        title: Text("Model1"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              margin: EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Model1",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "Latest version:",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "Last update",
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
                                Text("Download latest version"),
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
                child: ListView(
                  itemExtent: 50,
                  children: [
                    _versionItem(
                        "1.0.0", DateTime.now().subtract(Duration(hours: 1))),
                    _versionItem(
                        "0.9.0", DateTime.now().subtract(Duration(hours: 2))),
                    _versionItem(
                        "0.8.9", DateTime.now().subtract(Duration(hours: 3))),
                    _versionItem(
                        "0.8.8", DateTime.now().subtract(Duration(hours: 4))),
                    _versionItem(
                        "0.7.5", DateTime.now().subtract(Duration(hours: 5))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
