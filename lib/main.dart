import 'package:auction/config/theme.dart';
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // 이 줄 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,  // 이 옵션 추가
    );
    print('Firebase Initialized Successfully');
  } catch (e) {
    print('Firebase Initialization Error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: lightThemeData(),

    );
  }
}
