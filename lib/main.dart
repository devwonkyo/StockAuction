import 'package:auction/config/theme.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/theme_provider.dart';
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/auth/settings_screen.dart';
import 'package:auction/screens/auth/my_screen.dart';
import 'package:auction/screens/chat/chat_list_screen.dart';
import 'package:auction/screens/post/post_list_screen.dart';
import 'package:auction/screens/main_screen.dart';
import 'package:auction/route.dart';
import 'dart:async';
//firebase 패키지
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()), //테마 변경 Provider
        ChangeNotifierProvider(create: (context) => PostProvider()), //포스트 Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
    // return MaterialApp(
    //   home: MainScreen(),
    //   theme: lightThemeData(),

    // );
  }
}
