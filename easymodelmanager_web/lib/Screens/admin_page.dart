import 'dart:async';
import 'dart:convert';

import 'package:easymodelmanager_web/Screens/model_list.dart';
import 'package:easymodelmanager_web/helpers/api_handler.dart';
import 'package:easymodelmanager_web/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/user_model.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:validators/validators.dart' as validators;

class AdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  bool _isLogined = false;
  bool _isDarkTheme = false;

  int _sizeStatistic;
  List<UserModel> _users;

  void editUser(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute<ModelsListScreen>(
          builder: (context) => ModelsListScreen(user: user)),
    );
  }

  ApiHandler api;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _isDarkTheme = ThemeProvider.themeOf(context).id == 'dark';
      
    });
  }

  void _initLogin() {
    _isLogined = true;

    api = Provider.of<ApiHandler>(context, listen: false);

    api.getUsers().then((users) {
      setState(() {
        _users = users;
      });
    });

    //TODO: create statistic model
    api.getStatistic().then((body) {
      final statistic = json.decode(body);
      setState(() {
        _sizeStatistic = statistic['summarySize'] as int;
      });
    });
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Statistic'),
                    Text('Summary data size: $_sizeStatistic'),
                    Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    Expanded(
                      child: _users == null
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, i) {
                                return UserViewItem(_users[i], editUser);
                              },
                            ),
                    )
                  ],
                ),
              )
            : AdminAuthForm(_initLogin));
  }
}

class UserViewItem extends StatelessWidget {
  final UserModel user;
  final void Function(UserModel) onOpenDescription;

  UserViewItem(this.user, this.onOpenDescription);

  //TODO: Complete Admin Panel
  void _delete() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('id: ${user.id}'),
                  Text('username: ${user.name}'),
                  Text('password hash: ${user.password}'),
                  Text('rights: ${user.userType}'),
                ],
              ),
              Spacer(),
              RaisedButton(
                onPressed: _delete,
                child: Icon(Icons.delete),
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                onPressed: () => onOpenDescription(user),
                child: Icon(Icons.description),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminAuthForm extends StatefulWidget {
  final void Function() onSuccessfulLogin;

  AdminAuthForm(this.onSuccessfulLogin);

  @override
  State<StatefulWidget> createState() => AdminAuthFormState();
}

class AdminAuthFormState extends State<AdminAuthForm> {
  final Map<String, String> _userParameters = {
    'email': null,
    'login': null,
    'pass': null,
  };

  final _loginFormKey = GlobalKey<FormState>();
  var _loginStausText = '';

  ApiHandler api;

  @override
  void initState() {
    super.initState();
    Timer.run(() => api = Provider.of<ApiHandler>(context, listen: false));
  }

  Future _tryLogin() async {
    api = Provider.of<ApiHandler>(context, listen: false);
    api.setUserParams(_userParameters['login'], _userParameters['pass']);
    final user = await api.login(adminCheck: true);
    if (user != null) {
      widget.onSuccessfulLogin();
    } else {
      setState(() {
        _loginStausText = 'Invalid Login/Password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      validator: (value) => validators.isAlphanumeric(value)
                          ? null
                          : 'Login can contains only letters and numbers',
                      onSaved: (value) => _userParameters['login'] = value,
                      decoration: InputDecoration(
                        labelText: 'Login',
                      ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
                      ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
    );
  }
}
