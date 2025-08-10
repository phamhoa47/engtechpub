import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<String> onClickNotification =
      StreamController<String>.broadcast();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      onClickNotification.add(notificationResponse.payload!);
    }
  }

  static Future<void> init() async {
    tz.initializeTimeZones();

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsDarwin,
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Thông báo ngay lập tức
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'simple_channel',
        'Simple Notifications',
        channelDescription: 'Immediate notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Lịch thông báo hàng ngày hoặc test nhanh
  static Future<void> showDailyScheduleNotification({
    required String title,
    required String body,
    required String payload,
    bool isTest = false, // 🔹 Thêm tham số test
  }) async {
    tz.initializeTimeZones();

    const NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'daily_channel',
        'Daily Notifications',
        channelDescription: 'Daily or test notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    if (isTest) {
      // 📌 Test mode: 1 phút sau
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } else {
      // 📌 Daily mode: 20:00 hằng ngày
      final now = tz.TZDateTime.now(tz.local);
      var scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        2,
        15,
      );
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        title,
        body,
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }

  /// Huỷ 1 thông báo
  static Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Huỷ tất cả thông báo
  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
