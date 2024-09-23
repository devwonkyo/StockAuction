import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/auth/settings_screen.dart';
import 'package:auction/screens/auth/my_screen.dart';
import 'package:auction/screens/chat/chat_list_screen.dart';
import 'package:auction/screens/post/post_list_screen.dart';
import 'package:auction/screens/post/post_add_screen.dart';
import 'package:auction/screens/post/post_detail_screen.dart';
import 'package:auction/screens/main_screen.dart';
import 'screens/my/my_sold_screen.dart';
import 'screens/my/my_account_screen.dart';
import 'screens/my/my_bought_screen.dart';
import 'screens/my/my_deliver_screen.dart';
import 'screens/my/my_infoupdate_screen.dart';

// 보통 아래와 같은 방식으로 이동 가능합니다
// GoRouter.of(context).go('/example');
// GoRouter.of(context).push('/example');

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/main',
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/post/add',
      builder: (context, state) => PostAddScreen(),
    ),
    GoRoute(
      path: '/post/detail',
      builder: (context, state) => PostDetailScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/my',
      builder: (context, state) => MyScreen(),
    ),
    GoRoute(
      path: '/infoupdate',
      builder: (context, state) => MyInfoUpdateScreen(),
    ),
    GoRoute(
      path: '/deliver',
      builder: (context, state) => MyDeliverScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => MyAccountScreen(),
    ),
    GoRoute(
      path: '/sold',
      builder: (context, state) => MySoldScreen(),
    ),
    GoRoute(
      path: '/bought',
      builder: (context, state) => MyBoughtScreen(),
    ),
  ],
);
