import 'package:flutter/material.dart';
import 'package:growy/provider/dart_theme_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  get color => getTheme ? Colors.green : Colors.white;
}