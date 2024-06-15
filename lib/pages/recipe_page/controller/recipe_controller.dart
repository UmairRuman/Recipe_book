import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeController extends GetxController {
  static const _videoError = 'No Video Available';
  static const _recipeError = 'No Recipe Available';

  final DBHelper _db = DBHelper();
  var favourtieIcon = const Icon(Icons.favorite_border_outlined).obs;

  void scheduleNotification(BuildContext context, Meal meal) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (await LocalNotificationService().requestNotificationPermission()) {
      if (time != null) {
        var currentDateTime = DateTime.now();
        var scheduledTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            time.hour,
            time.minute,
            currentDateTime.second,
            currentDateTime.millisecond,
            currentDateTime.microsecond);
        LocalNotificationService().setTimerNotification(scheduledTime, meal);
      }
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
          }
        }
        if (key.startsWith('strMeasure')) {
          if ((value as String).isNotEmpty) {
            quantityList.add(value);
          }
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
          .showSnackBar(const SnackBar(content: Text(_videoError)));
    }
  }

  void openOriginalRecipe(BuildContext context, String recipeUrl) async {
    Uri uri = Uri.parse(recipeUrl);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(_recipeError)));
    }
  }

  void addMealToFavouruites(Meal meal) {
    _db.insert(meal);
  }

  void removeMealFromFavourites(Meal meal) {
    _db.delete(meal);
  }

  bool isFavourite(Meal meal) {
    return _db.isFavourite(meal);
  }

  void onFavouriteIconTap(Meal meal) {
    if (_db.isFavourite(meal)) {
      log('[removed from favourites]');
      _db.delete(meal);
      favourtieIcon.value = const Icon(Icons.favorite_border_outlined);
    } else {
      log('[added to favourites]');
      _db.insert(meal);
      favourtieIcon.value = const Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }
}
