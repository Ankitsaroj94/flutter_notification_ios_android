import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/global_methods.dart';

abstract class NotificationHandler {
  static bool _isInitialHandled = false;
  static void init() async {
    final initialNotification = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialNotification != null && !_isInitialHandled) {
      _isInitialHandled = true;
      _handleRemoteNotification(initialNotification);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleRemoteNotification(message);
    });
  }

  static void _handleRemoteNotification(RemoteMessage message) {
    final data = message.data;
    if (data.isNotEmpty) {
      handleNotification(jsonEncode(data));
    }
  }

  static void handleNotification(String payload) {
    GlobalMethods.errorSnackBar(message: payload);
  }
}
