import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
        _handleMessage(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'auction_end') {
      _showAuctionEndNotification(message);
    } else {
      _showGeneralNotification(message);
    }
  }

  Future<void> _showAuctionEndNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'auction_end_channel',
      'Auction End Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "경매 종료",
      message.notification?.body ?? "당신의 경매가 종료되었습니다.",
      platformChannelSpecifics,
      payload: message.data['auction_id'],
    );
  }

  Future<void> _showGeneralNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    print("recived push title : ${message.notification?.title ?? "알림"},data : ${message.data}");

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "알림",
      message.notification?.body ?? "",
      platformChannelSpecifics,
    );
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> showCustomNotification({required String title, required String body}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

}