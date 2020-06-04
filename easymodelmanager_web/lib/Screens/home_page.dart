import 'package:easymodelmanager_web/Screens/auth_page.dart';
import 'package:easymodelmanager_web/styles.dart';

import 'model_list.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:shared_models/user_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _darkTheme = false;
  UserModel _logginedUser;

  void successfulLogin(UserModel userModel) {
    setState(() {
      _logginedUser = userModel;
    });
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
                child: _logginedUser == null
                    ? Container()
                    : TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ).applyDefaults(whiteInputDecorationTheme),
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
        child: _logginedUser != null
            ? ModelsListScreen(
                user: _logginedUser,
              )
            : AuthPage(
                onSuccessfulLogin: successfulLogin,
              ),
      ),
    );
  }
}
