import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static const _notificationId = 1;
  static const _channelId = 'Schedule_1', _channelName = 'Recipe Timer';
  static const _timerBody = 'Time\'s Up!';
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

  Future<bool> requestNotificationPermission() async {
    if (_androidFlutterLocalNotificationsPlugin != null) {
      return await _androidFlutterLocalNotificationsPlugin!
              .requestNotificationsPermission() ??
          false;
    }
    return false;
  }

  // void setTimerNotification(DateTime dateTime, String title, String url) async {
  //   var imageUrl = url;
  //   log(imageUrl);
  //   final largeIcon =
  //       ByteArrayAndroidBitmap(await _getByteArrayFromUrl(imageUrl));
  //   log(largeIcon.toString());
  //   final AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(_channelId, _channelName,
  //           largeIcon: largeIcon);
  //   final NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //       _notificationId,
  //       title,
  //       _timerBody,
  //       tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Karachi')),
  //       notificationDetails,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  // }

  // Future<Uint8List> _getByteArrayFromUrl(String url) async {
  //   final Response response = await get(Uri.parse(url));
  //   return response.bodyBytes;
  // }

  void setTimerNotification(DateTime dateTime, String title, String url) async {
    //set the large icon with the meal image
    final largeIcon = ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));
    //set android details
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(_channelId, _channelName,
            largeIcon: largeIcon);
    //set notification details
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    //schedule Notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        _notificationId,
        title,
        _timerBody,
        tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Karachi')),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    const bytesTargetSize = 70000;
    final Response response = await get(Uri.parse(url));
    if (response.bodyBytes.length > bytesTargetSize) {
      //call the function to resize the image
      var resizedBytes =
          await resizeImageBytes(response.bodyBytes, bytesTargetSize);
      return resizedBytes!;
    } else {
      log('${response.bodyBytes.length}');
    }
    return response.bodyBytes;
  }

  Future<Uint8List?> resizeImageBytes(
      Uint8List imageBytes, int targetSize) async {
    try {
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage != null) {
        // initial quality
        int quality = 80;

        //  resize and compress the image until the target size is met or exceeded
        while (true) {
          // Encode the resized image to bytes with the current quality setting
          Uint8List resizedImageBytes = Uint8List.fromList(
              img.encodeJpg(originalImage, quality: quality));

          // Check if the resized image meets the target size
          if (resizedImageBytes.length <= targetSize) {
            log('Resized image bytes: ${resizedImageBytes.length} bytes');
            return resizedImageBytes;
          }

          // If not, decrease the quality and try again
          quality -= 5;

          // Ensure quality doesn't go below 10
          if (quality < 10) {
            log('Could not resize image within target size.');
            return null;
          }
        }
      } else {
        log('Failed to decode original image');
      }
    } catch (e) {
      log('Error resizing image: $e');
    }
    return null;
  }
}
