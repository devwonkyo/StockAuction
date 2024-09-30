import 'package:auction/config/theme.dart';
import 'package:auction/firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:auction/models/user_model.dart';
import 'package:auction/utils/notification_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auction/route.dart';

// provider 패키지 및 파일
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );// Firebase 초기화
  await _callHelloWorldFunction();
  await Firebase.initializeApp();


  // Firebase Messaging 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final notificationHandler = NotificationHandler();
  await notificationHandler.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<NotificationHandler>.value(value: notificationHandler),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _callHelloWorldFunction() async {
  try {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'asia-northeast3').httpsCallable('helloWorld');
    final result = await callable.call();
    print("success : ${result.data}");
  } catch (e) {
    print("error : $e");
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final notificationHandler = Provider.of<NotificationHandler>(context, listen: false);

    // AuthProvider가 이미 초기화되어 있으므로 추가 초기화는 필요 없음

    // 현재 사용자 확인
    UserModel? currentUser = authProvider.currentUserModel;

    if (currentUser != null) {
      // 사용자가 로그인한 상태
      print("User is logged in: ${currentUser.nickname}");

      // UserProvider를 사용하여 최신 사용자 정보 가져오기
      await userProvider.fetchUser(currentUser.uid);

      // FCM 토큰 가져오기 및 등록
      final token = await notificationHandler.getToken();
      if (token != null) {
        print('FCM Token: $token');
        // FCM 토큰을 서버에 등록하는 로직 짜야합니다
        // 예: await authProvider.updateFCMToken(token);

      }
    } else {
      print("No user is currently logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          theme: themeProvider.currentTheme,
          darkTheme: darkThemeData(),
          themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
