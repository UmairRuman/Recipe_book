import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';

class RecipeController extends GetxController {
  void scheduleNotification(TimeOfDay time, String title) {
    LocalNotificationService().setTimerNotification(time, title);
  }

  (List<String>, List<String>) ingredientsAndQuantityList(
      Map<String, dynamic> mealMap) {
    final List<String> ingredientsList = [], quantityList = [];
    mealMap.forEach(
      (key, value) {
        if (key.startsWith('strIng')) {
          if ((value as String).isNotEmpty) {
            ingredientsList.add(value);
          } else {
            log('[key : $key , value : $value]');
          }
        }
        if (key.startsWith('strMeasure')) {
          if ((value as String).isNotEmpty) {
            quantityList.add(value);
          }
        } else {
          log('[key : $key , value : $value]');
        }
      },
    );
    return (ingredientsList, quantityList);
  }
}
