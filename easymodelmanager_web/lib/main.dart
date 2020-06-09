import 'package:easymodelmanager_web/Screens/admin_page.dart';
import 'package:easymodelmanager_web/styles.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'Screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [lightTheme, darkTheme],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: MaterialApp(
        title: 'ModelManager',
        initialRoute: '/',
        routes: {
          '/admin': (context) => ThemeConsumer(
            child: AdminPage()
          ),
          '/': (context) => ThemeConsumer(
                child: HomePage(
                  title: 'Easy Model Manager',
                ),
              ),
        },
      ),
    );
  }
}
