import "package:flutter/material.dart";
import "package:theme_provider/theme_provider.dart";
import "Screens/home_page.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [AppTheme.light(), AppTheme.dark()],
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: MaterialApp(
        title: "ModelManager",
        home: ThemeConsumer(child: HomePage(title: "Easy Model Manager")),
      ),
    );
  }
}