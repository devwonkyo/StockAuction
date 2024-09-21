import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDarkTheme = false;

  ThemeData get currentTheme => _isDarkTheme ? darkThemeData() : lightThemeData();

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}