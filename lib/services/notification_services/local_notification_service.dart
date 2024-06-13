import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static const _notificationId = 1;
  static const _channelId = 'Schedule_1', _channelName = 'Recipe Timer';
  static const _timerBody = 'Your time is Up';
  static LocalNotificationService? _instance;

  LocalNotificationService._();
  factory LocalNotificationService() =>
      _instance ??= LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin?
      _androidFlutterLocalNotificationsPlugin;

  Future<void> initializeNotifications() async {
    _androidFlutterLocalNotificationsPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    _flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<bool?> requestNotificationPermission() async {
    if (_androidFlutterLocalNotificationsPlugin != null) {
      return await _androidFlutterLocalNotificationsPlugin!
          .requestNotificationsPermission();
    }
    return false;
  }

  void setTimerNotification(TimeOfDay time, String title) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(_channelId, _channelName);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        _notificationId,
        title,
        _timerBody,
        tz.TZDateTime.from(
            DateTime.now()
                .add(Duration(hours: time.hour, minutes: time.minute)),
            tz.getLocation('Asia/Karachi')),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}
