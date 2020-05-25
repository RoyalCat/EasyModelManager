import "model_list.dart";
import "package:flutter/material.dart";
import "package:theme_provider/theme_provider.dart";

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkTheme = false;
  bool _loggined = true;
  String _key = "";


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
            ? ModelsListScreen(
              userKey: _key,
            ) :
            Container()
      ),
    );
  }
}