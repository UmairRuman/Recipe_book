// lib/services/notification_services/local_notification_service.dart

import 'dart:async';

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;


import 'package:image/image.dart' as img;
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static const _notificationId = 1;
  static const _channelId = 'Schedule_1', _channelName = 'Recipe Timer';
  static LocalNotificationService? _instance;
  final StreamController<String?> selectedNotificationStream =
      StreamController<String?>.broadcast();

  LocalNotificationService._();
  factory LocalNotificationService() =>
      _instance ??= LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin?
      _androidFlutterLocalNotificationsPlugin;

  Future<void> initializeNotifications() async {
    _androidFlutterLocalNotificationsPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _ondidRecieveNotificationHandler,
    );
  }

  Future<bool> requestNotificationPermission() async {
    if (_androidFlutterLocalNotificationsPlugin != null) {
      return await _androidFlutterLocalNotificationsPlugin!
              .requestNotificationsPermission() ??
          false;
    }
    return false;
  }

  void setTimerNotification(
    DateTime dateTime,
    Meal meal,
    String message,
  ) async {
    //set the large icon with the meal image
    final largeIcon = ByteArrayAndroidBitmap(
      await _getByteArrayFromUrl(meal.strMealThumb),
    );
    //set android details
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      largeIcon: largeIcon,
    );
    //set notification details
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    //schedule Notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      meal.strMeal,
      message,
      tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Karachi')),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: meal.toMap().toString(),
    );
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    const bytesTargetSize = 70000;
    final http.Response response = await http.get(Uri.parse(url));
    if (response.bodyBytes.length > bytesTargetSize) {
      //call the function to resize the image
      var resizedBytes = await resizeImageBytes(
        response.bodyBytes,
        bytesTargetSize,
      );
      return resizedBytes!;
    } else {
      log('${response.bodyBytes.length}');
    }
    return response.bodyBytes;
  }

  Future<Uint8List?> resizeImageBytes(
    Uint8List imageBytes,
    int targetSize,
  ) async {
    try {
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage != null) {
        // initial quality
        int quality = 80;

        //  resize and compress the image until the target size is met or exceeded
        while (true) {
          // Encode the resized image to bytes with the current quality setting
          Uint8List resizedImageBytes = Uint8List.fromList(
            img.encodeJpg(originalImage, quality: quality),
          );

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

  /// Determine initial route based on notification and auth state
  /// Returns the route name instead of Widget for better separation of concerns
Future<String?> getNotificationLaunchInfo() async {
  try {
    final NotificationAppLaunchDetails? appLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (appLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload = appLaunchDetails!.notificationResponse?.payload;
      if (payload != null) {
        log('📱 App opened from notification with payload');
        return payload;
      }
    }
    return null;
  } catch (e) {
    log('⚠️ Error getting notification launch info: $e');
    return null;
  }
}

// Keep the old method for backward compatibility but mark as deprecated
@Deprecated('Use getNotificationLaunchInfo() instead')
Future<String> getInitialRoute() async {
  try {
    final NotificationAppLaunchDetails? appLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (appLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload = appLaunchDetails!.notificationResponse!.payload;
      if (payload != null) {
        log('📱 App opened from notification with payload');
        selectedNotificationStream.add(payload);
        
        final storageService = Get.find<SecureStorageService>();
        final isLoggedIn = await storageService.isLoggedIn();
        
        if (isLoggedIn) {
          return AppRoutes.recipe;
        } else {
          return AppRoutes.auth;
        }
      }
    }

    final storageService = Get.find<SecureStorageService>();
    final isLoggedIn = await storageService.isLoggedIn();

    log('🔐 User login status: $isLoggedIn');

    if (isLoggedIn) {
      return AppRoutes.home;
    } else {
      return AppRoutes.auth;
    }
  } catch (e) {
    log('⚠️ Error determining initial route: $e');
    return AppRoutes.auth;
  }
}

void _ondidRecieveNotificationHandler(NotificationResponse details) {
  details.payload!.replaceAll('\n', '\\n').replaceAll('\r', '\\r');
  selectedNotificationStream.add(details.payload);
}
}