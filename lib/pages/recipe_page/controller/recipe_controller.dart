import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/widgets/timer_message_dialog.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeController extends GetxController {
  //data members
  final DBHelper _db = DBHelper();
  final TextEditingController timerMessageController = TextEditingController();
  static const iconsChache = <FavouriteIcons, Icon>{
    FavouriteIcons.unfavourite: Icon(Icons.favorite_border_rounded),
    FavouriteIcons.favourite: Icon(
      Icons.favorite_outlined,
      color: Colors.red,
    )
  };
  var favouriteIcon = iconsChache[FavouriteIcons.unfavourite]!.obs;

  //functions
  void scheduleNotification(BuildContext context, Meal meal) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (await LocalNotificationService().requestNotificationPermission()) {
      const defaultTimerMessage = 'Time\'s up!';
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
        String message = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const TimerMessageDialog(),
        );
        if (message.isEmpty) {
          LocalNotificationService()
              .setTimerNotification(scheduledTime, meal, defaultTimerMessage);
        } else {
          LocalNotificationService()
              .setTimerNotification(scheduledTime, meal, message);
        }
      }
    }
  }

  (List<String>, List<String>) ingredientsAndQuantityList(
      Map<String, dynamic> mealMap) {
    final List<String> ingredientsList = [], quantityList = [];
    mealMap.forEach(
      (key, value) {
        if (key.startsWith('"strIng')) {
          if ((value as String) != '""') {
            ingredientsList.add(trimQuotes(value));
          }
        }
        if (key.startsWith('"strMeasure')) {
          if ((value as String) != '""') {
            quantityList.add(trimQuotes(value));
          }
        }
      },
    );
    return (ingredientsList, quantityList);
  }

  // function to remove double quotation marks from strt and end of the string
  String trimQuotes(String input) {
    // pattern
    String pattern = r'^"+|"+$';
    // method
    return input.replaceAll(RegExp(pattern), '');
  }

  navigateBackToCategoryPage() {
    return Get.back();
  }

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

  void onFavouriteIconTap(Meal meal) {
    Meal currentMeal = meal.copiedObject;
    if (_db.isFavourite(meal.idMeal)) {
      _db.delete(currentMeal.idMeal);
      favouriteIcon.value = iconsChache[FavouriteIcons.unfavourite]!;
    } else {
      _db.insert(currentMeal);
      favouriteIcon.value = iconsChache[FavouriteIcons.favourite]!;
    }
  }

  void checkForFavouriteIcon(Meal meal) {
    if (_db.isFavourite(meal.idMeal)) {
      favouriteIcon.value = iconsChache[FavouriteIcons.favourite]!;
    } else {
      favouriteIcon.value = iconsChache[FavouriteIcons.unfavourite]!;
    }
  }

  void onOkBtnTap() {
    Get.back(result: timerMessageController.text);
    timerMessageController.clear();
  }

  @override
  void onClose() {
    timerMessageController.dispose();
    super.onClose();
  }
}

enum FavouriteIcons {
  favourite,
  unfavourite,
}
