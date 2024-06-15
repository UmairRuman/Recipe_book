import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredeints_quantity_list.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredient_and_quantity_design.dart';
import 'package:recipe_book/pages/recipe_page/widgets/recipe_tutorial_design.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class RecipePage extends GetView<RecipeController> {
  const RecipePage({super.key, this.selectedNotificationMeal});
  final Meal? selectedNotificationMeal;
  static const pageAddress = '/recipe';
  static const instructions = 'Instructions :';
  static const originalRecipeLink = 'Recipe link :';

  @override
  Widget build(BuildContext context) {
    final Meal meal;
    if (selectedNotificationMeal != null) {
      meal = selectedNotificationMeal!;
    } else {
      meal = Get.arguments;
    }
    bool isPresent = controller.isFavourite(meal);
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.03,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: DBHelper().deleteAll,
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => controller.scheduleNotification(context, meal),
              icon: const Icon(
                Icons.timer_outlined,
              )),
          IconButton(
              onPressed: () {
                if (isPresent) {
                  controller.removeMealFromFavourites(meal);
                  isPresent = false;
                } else {
                  controller.addMealToFavouruites(meal);
                  isPresent = true;
                }
              },
              icon: Obx(
                () => controller.favourtieIcon.value,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.3),
              child: CircleAvatar(
                radius: height * 0.1,
                backgroundImage: NetworkImage(meal.strMealThumb),
              ),
            ),
            RecipeAndTutorialDesign(
              recipeName: meal.strMeal,
              videoUrl: meal.strYoutube,
            ),
            const IngredientAndQuantityHeadings(),
            IngredientsQuantityList(
              ingredientsAndQuantityList:
                  controller.ingredientsAndQuantityList(meal.toMap()),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07),
              child: Text(
                instructions,
                style: style,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07),
              child: SizedBox(
                width: width * 0.8,
                child: Text(
                  meal.strInstructions,
                ),
              ),
            ),
            if (meal.strSource.isNotEmpty) LinkWidget(source: meal.strSource),
          ],
        ),
      ),
    );
  }
}

class LinkWidget extends GetView<RecipeController> {
  const LinkWidget({super.key, required this.source});
  final String source;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.07, top: height * 0.02, bottom: height * 0.02),
      child: SizedBox(
        width: width * 0.85,
        child: GestureDetector(
          onTap: () {
            controller.openOriginalRecipe(context, source);
          },
          child: RichText(
              text: TextSpan(children: [
            const TextSpan(
              text: '\u{1F517}',
            ),
            TextSpan(
                text: source,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ))
          ])),
        ),
      ),
    );
  }
}
