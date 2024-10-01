import 'package:auction/screens/my/my_bid_screen.dart';
import 'package:auction/screens/post/post_modify_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auction/screens/main_screen.dart';
// import auth
import 'package:auction/screens/auth/login_screen.dart';
import 'package:auction/screens/auth/signup_screen.dart';
import 'package:auction/screens/auth/password_reser_screen.dart';
// import chat
import 'package:auction/screens/chat/chat_list_screen.dart';
import 'package:auction/screens/chat/chat_screen.dart';
// import post
import 'package:auction/screens/post/post_list_screen.dart';
import 'package:auction/screens/post/post_add_screen.dart';
import 'package:auction/screens/post/post_detail_screen.dart';
import 'package:auction/screens/post/bid_list_screen.dart';
// import my
import 'package:auction/screens/my/my_screen.dart';
import 'package:auction/screens/my/my_sold_screen.dart';
import 'package:auction/screens/my/my_account_screen.dart';
import 'package:auction/screens/my/my_bought_screen.dart';
import 'package:auction/screens/my/my_infoupdate_screen.dart';
// import other
import 'package:auction/screens/other/other_profile_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/login',
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => PasswordResetScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/main/post',
      builder: (context, state) => MainScreen(pageIndex: 1),
    ),
    GoRoute(
      path: '/main/chat',
      builder: (context, state) => MainScreen(pageIndex: 2),
    ),
    GoRoute(
      path: '/main/like',
      builder: (context, state) => MainScreen(pageIndex: 3),
    ),
    GoRoute(
      path: '/post/add',
      builder: (context, state) => PostAddScreen(),
    ),
    GoRoute(
      path: '/post/modify',
      builder: (context, state) => PostModifyScreen(),
    ),
    GoRoute(
      path: '/post/detail/:postUid',
      builder: (context, state) {
        final postUid = state.pathParameters['postUid'];
        if (postUid == null || postUid == 'null') {
          return ErrorScreen('Invalid Post ID');
        }
        return PostDetailScreen(postUid: postUid);
      },
    ),
    GoRoute(
      path: '/post/list',
      builder: (context, state) => PostListScreen(),
    ),
    GoRoute(
      path: '/post/bidList/:postUid',
      builder: (context, state) {
        final postUid = state.pathParameters['postUid'] ?? '';
        return BidListScreen(postUid: postUid);
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId'];
        if (chatId == null) {
          return ErrorScreen('Chat ID is missing');
        }
        return ChatScreen(chatId: chatId);
      },
    ),
    GoRoute(
      path: '/PostListScreen',
      builder: (context, state) => PostListScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatListScreen(),
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
    GoRoute(
      path: '/other/profile/:uId',
      builder: (context, state) {
        final uId = state.pathParameters['uId'];
        if (uId == null) {
          return ErrorScreen('User ID is missing');
        }
        return OtherProfileScreen(uId: uId);
      },
    ),
    GoRoute(
      path: '/my-bids',
      builder: (context, state) => MyBidsScreen(),
    ),
  ],
);

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}