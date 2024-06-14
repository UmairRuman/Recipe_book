import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeController extends GetxController {
  void scheduleNotification(BuildContext context, String title) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (time != null) {
      LocalNotificationService().setTimerNotification(time, title);
    }
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

  void navigateBackToCategoryPage() => Get.back();

  void openYoutubeVideo(BuildContext context, String videoUrl) async {
    Uri uri = Uri.parse(videoUrl);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No Video Available')));
    }
  }

  void openOriginalRecipe(BuildContext context, String recipeUrl) async {
    Uri uri = Uri.parse(recipeUrl);
    if (!await launchUrl(uri)) {}
  }
}
