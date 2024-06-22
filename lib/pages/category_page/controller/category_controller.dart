import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/meal_services/recipe_service/recipe_Service.dart';

class CategoryController extends GetxController {
  final DBHelper _db = DBHelper();
  static const _iconsChache = <FavouriteIcons, Icon>{
    FavouriteIcons.unfavourite: Icon(Icons.favorite_border_rounded),
    FavouriteIcons.favourite: Icon(
      Icons.favorite_outlined,
      color: Colors.red,
    )
  };
  var iconsList = <Icon>[].obs;

  //go to recipe page on recipe click
  navigateToRecipePage(mealName, int index, VoidCallback stateFunc) async {
    var favouritesLength = DBHelper().favouriteMeals().length;
    RecipeService recipeService = RecipeService();
    var mealResponse = await recipeService.getMeal(mealName: mealName);
    var response = await Get.toNamed(
      RecipePage.pageAddress,
      arguments: mealResponse.meals[0],
    );
    if (response != favouritesLength) {
      stateFunc();
    }
  }

  //add or remove on favourite icon tap
  onFavouriteIconTap(CategoryItem category, int index) async {
    if (_db.isFavourite(category.idMeal)) {
      _db.delete(category.idMeal);
      iconsList[index] = _iconsChache[FavouriteIcons.unfavourite]!;
      iconsList.refresh();
    } else {
      iconsList[index] = _iconsChache[FavouriteIcons.favourite]!;
      iconsList.refresh();
      var meal = await _convertCategoryToMeal(category.strMeal);
      _db.insert(meal.copiedObject);
    }
  }

  Future<Meal> _convertCategoryToMeal(String mealName) async {
    var mealResposne = await RecipeService().getMeal(mealName: mealName);
    return mealResposne.meals[0];
  }

  checkForFavouriteIcon(String mealId, int index) {
    if (_db.isFavourite(mealId)) {
      iconsList[index] = _iconsChache[FavouriteIcons.favourite]!;
    } else {
      iconsList[index] = _iconsChache[FavouriteIcons.unfavourite]!;
    }
    iconsList.refresh();
  }
}
