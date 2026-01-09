import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../firebase_options.dart';
import 'notification_handler.dart';

abstract class NotificationService {
  static final isPermissionAllowed = ValueNotifier(false);
  static final isNotificationTileDismissed = ValueNotifier(false);
  static Future<bool> init() async {
    await requestPermission(checkOnly: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupFlutterNotifications();
    NotificationHandler.init();
    return isPermissionAllowed.value;
  }

  static Future<void> requestPermission({
    bool showSettings = false,
    bool checkOnly = false,
  }) async {
    final status = await Permission.notification.status;
    isPermissionAllowed.value = status == .granted;
    if (checkOnly) {
      return;
    }
    if (status != .granted) {
      final req = await Permission.notification.request();
      isPermissionAllowed.value = req == .granted;
      if (req == .permanentlyDenied && showSettings) {
        await openAppSettings();
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

bool isFlutterLocalNotificationsInitialized = false;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  if (Platform.isAndroid) {
    channel = const AndroidNotificationChannel(
      'SMT_NOTIFICATIONS',
      'SMT App Notifications',
      importance: .high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          NotificationHandler.handleNotification(payload);
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  final notification = message.notification;
  final android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }
}
