import 'package:auction/screens/main_screen.dart';
import 'package:auction/screens/post/post_detail_screen.dart';
import 'package:flutter/material.dart';

import 'config/theme.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: lightThemeData(),

    );
  }
}
