import 'package:flutter/material.dart';

ThemeData darkThemeData() {
  return ThemeData(
    primaryColor: Colors.white,
    primarySwatch: Colors.grey,
    hintColor: Colors.tealAccent,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey[800],
      textTheme: ButtonTextTheme.normal,
    ),
    colorScheme: const ColorScheme.dark( // 다크 모드 색상 설정
      primary: Colors.white
    ),
    brightness: Brightness.dark,  // 다크 모드 명시
  );
}



ThemeData lightThemeData() {
  return ThemeData(
    primaryColor: Color(0xFF1E1E1F),
    primarySwatch: Colors.blue,
    hintColor: Colors.orange,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      displayLarge: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.red,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: const ColorScheme.light( // 다크 모드 색상 설정
        primary: Colors.black
    ),
    brightness: Brightness.light,  // 라이트 모드 명시
  );
}