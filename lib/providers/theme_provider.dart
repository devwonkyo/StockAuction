import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';

class ThemeProvider with ChangeNotifier{
  bool _isDarkTheme = false;

  ThemeData get currentTheme => _isDarkTheme ? darkThemeData() : lightThemeData();

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}