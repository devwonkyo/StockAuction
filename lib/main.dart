import 'package:auction/config/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auction/route.dart';
// provider 패키지 및 파일 무저ㅣ잉이이
import 'package:provider/provider.dart';
import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/theme_provider.dart';
import 'package:auction/providers/chat_provider.dart';
import 'package:auction/providers/auth_provider.dart';
import 'package:auction/providers/my_provider.dart';
import 'package:auction/providers/user_provider.dart';
// firebase 패키지
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider()), //테마 변경 Provider
        ChangeNotifierProvider(
            create: (context) => PostProvider()), //포스트 Provider
        ChangeNotifierProvider(
            create: (context) => ChatProvider()), // 채팅 Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => MyProvider()),
        ChangeNotifierProvider(
          create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: Provider.of<ThemeProvider>(context)
          .currentTheme, //todo toggle 시 Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      // theme: darkThemeData(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
