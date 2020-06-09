import 'dart:convert';

import 'package:easymodelmanager_web/app_config.dart';
import 'package:easymodelmanager_web/helpers/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/user_model.dart';
import 'package:validators/validators.dart' as validators;
import 'package:http/http.dart' as http;


class AuthPage extends StatefulWidget {
  final void Function(UserModel) onSuccessfulLogin;

  AuthPage({
    Key key,
    this.onSuccessfulLogin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _loginAutoValidate = false;
  bool _registerAutoValidate = false;

  final _loginFormKey = GlobalKey<FormState>();
  var _loginStausText = '';

  final _registerFormKey = GlobalKey<FormState>();
  var _registerStatusText = '';

  AppConfig _config;

  @override
  void initState() {
    AppConfig.forEnvironment().then((value) => _config = value);
    super.initState();
  }

  final Map<String, String> _userParameters = {
    'email': null,
    'login': null,
    'pass': null,
  };

  Future _tryRegisterLogin() async {
    var response = await http.post(
      '${_config.apiUrl}/signup',
      headers: {
        'Content-type': 'application/json'
      },
      body: jsonEncode({
        'name': _userParameters['login'],
        'password': generateMd5(_userParameters['pass']),
      }),
    );
    if(response.statusCode == 200)
    {
      await _tryLogin();
    } else {
      setState(() {
        _registerStatusText = 'Registration failed';
      });
    }
  }

  Future _tryLogin() async {
    final response = await sendAuthorisedGet('/login',_userParameters, _config);
    if (response.statusCode == 200) {
      widget.onSuccessfulLogin(
        UserModel(_userParameters['login'], _userParameters['pass']),
      );
    } else {
      setState(() {
        _loginStausText = 'Invalid Login/Password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Form(
                    key: _loginFormKey,
                    autovalidate: _loginAutoValidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) => validators.isAlphanumeric(value)
                              ? null
                              : 'Login can contains only letters and numbers',
                          onSaved: (value) => _userParameters['login'] = value,
                          decoration: InputDecoration(
                            labelText: 'Login',
                          ).applyDefaults(
                              Theme.of(context).inputDecorationTheme),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          validator: (value) => validators.isAlphanumeric(value)
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
                              } else {
                                setState(() {
                                  _loginAutoValidate = true;
                                }); 
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
        VerticalDivider(
          thickness: 2,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Sign up',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Form(
                    key: _registerFormKey,
                    autovalidate: _registerAutoValidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) => validators.isEmail(value)
                              ? null
                              : 'Invalid Email',
                          onSaved: (value) => _userParameters['email'] = value,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ).applyDefaults(
                              Theme.of(context).inputDecorationTheme),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          validator: (value) => validators.isAlphanumeric(value)
                              ? null
                              : 'Login can contains only letters and numbers',
                          onSaved: (value) => _userParameters['login'] = value,
                          decoration: InputDecoration(
                            labelText: 'Login',
                          ).applyDefaults(
                              Theme.of(context).inputDecorationTheme),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          validator: (value) => validators.isAlphanumeric(value)
                              ? null
                              : 'Password can contains only letters and numbers',
                          onSaved: (value) => _userParameters['pass'] = value,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ).applyDefaults(
                              Theme.of(context).inputDecorationTheme),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          width: 150,
                          child: RaisedButton(
                            child: Text('Sign up'),
                            onPressed: () {
                              if (_registerFormKey.currentState.validate()) {
                                _registerFormKey.currentState.save();
                                _tryRegisterLogin();
                              } else {
                                setState(() {
                                  _registerAutoValidate = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _registerStatusText,
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
      ],
    );
  }
}
