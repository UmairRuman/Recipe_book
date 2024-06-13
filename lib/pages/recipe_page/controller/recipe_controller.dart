import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';

class RecipeController extends GetxController {
  void scheduleNotification(TimeOfDay time, String title) {
    LocalNotificationService().setTimerNotification(time, title);
  }
}
