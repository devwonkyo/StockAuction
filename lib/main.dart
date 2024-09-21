import 'package:auction/providers/post_provider.dart';
import 'package:auction/providers/theme_provider.dart';
import 'package:auction/screens/main_screen.dart';
import 'package:auction/screens/post/post_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()), //테마 변경 Provider
        ChangeNotifierProvider(create: (context) => PostProvider()), //포스트 Provider
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostDetailScreen(),
      theme: Provider.of<ThemeProvider>(context).currentTheme, //todo toggle 시 Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); 로 사용
      // theme: darkThemeData(),

    );
  }
}
