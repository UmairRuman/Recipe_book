import 'dart:developer';

import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/meal_services/recipe_service/recipe_Service.dart';

class CategoryController extends GetxController {
  void navigateToRecipePage({required String mealName}) async {
    log('navigate function called');
    RecipeService recipeService = RecipeService();
    var mealResponse = await recipeService.getMeal(mealName: mealName);
    Get.toNamed(
      RecipePage.pageAddress,
      arguments: mealResponse.meals[0],
    );
  }
}
