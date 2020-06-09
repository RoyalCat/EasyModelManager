import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:easymodelmanager_web/helpers/auth_helpers.dart';
import 'package:easymodelmanager_web/styles.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart' as validators;

import '../app_config.dart';



class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  AppConfig _config;

  bool _isLogined = true;
  bool _isDarkTheme = false;
  final _loginFormKey = GlobalKey<FormState>();
  var _loginStausText = '';

  int _sizeStatistic = null;

  final Map<String, String> _userParameters = {
    'email': null,
    'login': null,
    'pass': null,
  };

  @override
  void initState() {
    AppConfig.forEnvironment().then((value) => _config = value);
    Timer.run(() { 
      _isDarkTheme = ThemeProvider.themeOf(context).id == 'dark';
    });
    super.initState();
  }

  void _initLogin()
  {
    _isLogined = true;
    sendAuthorisedGet('/admin/get_statistic' ,_userParameters, _config).then((response) {
      final statistic = json.decode(response.body);
      setState(() {
        _sizeStatistic = statistic['summarySize'] as int;
      });
    });
  }

  Future _tryLogin() async {
    final response = await sendAuthorisedGet('/admin/login', _userParameters, _config);
    if (response.statusCode == 200) {
      setState(_initLogin);
    } else {
      setState(() {
        _loginStausText = 'Invalid Login/Password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Easy Model Manager Admin Panel',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [ 
                  Spacer(),
                  Switch(
                    value: _isDarkTheme,
                    onChanged: (value) {
                      _isDarkTheme = value;
                      ThemeProvider.controllerOf(context).setTheme(
                        _isDarkTheme ? darkTheme.id : lightTheme.id,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLogined
          ? Container(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Статистика"),
                Text("Обший объем данных: $_sizeStatistic"),
                Divider(
                  height: 10,
                  thickness: 2,
                ),
                Expanded(
                  child: ListView(
                  children: [
                    Text('тут будет список пользователей'),
                    ],
                  ),
                )
                
              ],
            ),
          )
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 300,
                      child: Form(
                        key: _loginFormKey,
                        autovalidate: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) => validators
                                      .isAlphanumeric(value)
                                  ? null
                                  : 'Login can contains only letters and numbers',
                              onSaved: (value) =>
                                  _userParameters['login'] = value,
                              decoration: InputDecoration(
                                labelText: 'Login',
                              ).applyDefaults(
                                  Theme.of(context).inputDecorationTheme),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value) => validators
                                      .isAlphanumeric(value)
                                  ? null
                                  : 'Password can contains only letters and numbers',
                              obscureText: true,
                              onSaved: (value) => _userParameters['pass'] = value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ).applyDefaults(
                                  Theme.of(context).inputDecorationTheme),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: 150,
                              child: RaisedButton(
                                child: Text('Login'),
                                onPressed: () {
                                  if (_loginFormKey.currentState.validate()) {
                                    _loginFormKey.currentState.save();
                                    _tryLogin();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _loginStausText,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
