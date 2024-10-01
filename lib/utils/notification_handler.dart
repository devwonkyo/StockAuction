import 'dart:convert';

import 'package:auction/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoRouter router;

  NotificationHandler({required this.router});

  Future<void> initialize() async {
    await _requestAndroidPermissions();
    await _configureLocalNotifications();
    await _configureFCM();
  }

  Future<void> _requestAndroidPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _configureLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      Map<String, dynamic> payloadData;
      try {
        // JSON으로 파싱 시도
        payloadData = json.decode(response.payload!);
      } catch (e) {
        // JSON 파싱 실패 시 수동 파싱
        payloadData = _manualParsePayload(response.payload!);
      }

      final screen = payloadData['screen'] as String?;
      final postUid = payloadData['postUid'] as String?;
      final chatId = payloadData['chatId'] as String?;

      if (screen == '/chat' && chatId != null) {
        router.push('/chat/$chatId');
      } else if (screen != null && postUid != null) {
        router.push('$screen/$postUid');
      }
    }
  }

  Map<String, String> _manualParsePayload(String payload) {
    // 중괄호 제거 및 쉼표로 분리
    final pairs = payload.substring(1, payload.length - 1).split(', ');

    // 각 키-값 쌍을 파싱
    return Map.fromEntries(pairs.map((pair) {
      final parts = pair.split(': ');
      if (parts.length != 2) throw FormatException('Invalid payload format');
      return MapEntry(
          parts[0].trim().replaceAll("'", ""),
          parts[1].trim().replaceAll("'", "")
      );
    }));
  }

  Future<void> _configureFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Received message: ${message.notification?.title}");
        _handleMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Opened app from notification");
        _handleMessageOpenedApp(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showNotification(message);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final String? screen = message.data['screen'];
    final String? postUid = message.data['postUid'];
    final String? chatId = message.data['chatId'];

    if (screen == '/chat' && chatId != null) {
      router.push('/chat/$chatId');
    } else if (screen != null && postUid != null) {
      router.push('$screen/$postUid');
    } else if (screen != null) {
      router.push(screen);
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    final payload = {
      'screen': message.data['screen'],
      'postUid': message.data['postUid'],
      'chatId': message.data['chatId'],
    };

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "알림",
      message.notification?.body ?? "",
      platformChannelSpecifics,
      payload: payload.toString(),
    );
  }

  Future<void> showCustomNotification({
    required String title,
    required String body,
    required String screen,
    String? postUid,
    String? chatId,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    final payload = {
      'screen': screen,
      if (postUid != null) 'postUid': postUid,
      if (chatId != null) 'chatId': chatId,
    };

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload.toString(),
    );
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}