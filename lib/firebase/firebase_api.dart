import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // iOS yêu cầu quyền
    await _firebaseMessaging.requestPermission();

    // Lấy token
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $fcmToken");

    // Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("📩 Foreground: ${message.notification?.title}");
    });

    // Khi app mở từ background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("📩 Click notification: ${message.notification?.title}");
    });
  }
}
