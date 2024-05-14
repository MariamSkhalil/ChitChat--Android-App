import 'package:chitchat/themes/dark_mode.dart';
import 'package:chitchat/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentThemeData = lightmode;

  ThemeData get themeData => _currentThemeData;

  bool get isDarkMode => _currentThemeData == darkmode;

  set themeData(ThemeData themeData) {
    _currentThemeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_currentThemeData == lightmode) {
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}