// lib/pages/category_page/controller/category_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/meal_services/category_service/category_service.dart';

import 'package:recipe_book/services/recipe_service/view/recipe_service.dart';

enum FavouriteIcons { unfavourite, favourite }

class CategoryController extends GetxController {
  final DBHelper _db = DBHelper();
  final CategoryService _categoryService = CategoryService();
  
  static const _iconsCache = <FavouriteIcons, Icon>{
    FavouriteIcons.unfavourite: Icon(Icons.favorite_border_rounded),
    FavouriteIcons.favourite: Icon(
      Icons.favorite_outlined,
      color: Colors.red,
    )
  };

  // Observable variables
  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxList<Icon> iconsList = <Icon>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString categoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Get the category name from arguments
    final dynamic argument = Get.arguments;
    
    if (argument is String) {
      // Coming from All Categories page or updated home page
      categoryName.value = argument;
      loadCategoryData(argument);
    } else if (argument is List<CategoryItem>) {
      // Legacy support: Coming from old navigation with list
      categories.value = argument;
      categoryName.value = 'Category'; // Default name
      _initializeIcons();
      isLoading.value = false;
    } else if (argument is Map && argument.containsKey('name')) {
      // Alternative: Coming with a map
      categoryName.value = argument['name'];
      loadCategoryData(argument['name']);
    } else {
      // Handle error
      hasError.value = true;
      errorMessage.value = 'Invalid category data';
      isLoading.value = false;
    }
  }

  /// Load category data from API
  Future<void> loadCategoryData(String category) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      log('Loading category: $category');
      
      final fetchedCategories = await _categoryService.fetchCategory(category);
      
      categories.value = fetchedCategories;
      _initializeIcons();
      
      log('Categories loaded: ${categories.length} items');
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load $category recipes: $e';
      log('Error loading category: $e');
      
      Get.snackbar(
        'Error',
        'Failed to load recipes',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Initialize favorite icons for all categories
  void _initializeIcons() {
    iconsList.clear();
    iconsList.addAll(
      List.generate(
        categories.length,
        (index) {
          if (_db.isFavourite(categories[index].idMeal)) {
            return _iconsCache[FavouriteIcons.favourite]!;
          } else {
            return _iconsCache[FavouriteIcons.unfavourite]!;
          }
        },
      ),
    );
  }

  /// Navigate to recipe page on recipe click
  Future<void> navigateToRecipePage(
    String mealName,
    int index,
    VoidCallback stateFunc,
  ) async {
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

  /// Add or remove on favourite icon tap
  Future<void> onFavouriteIconTap(CategoryItem category, int index) async {
    if (_db.isFavourite(category.idMeal)) {
      _db.delete(category.idMeal);
      iconsList[index] = _iconsCache[FavouriteIcons.unfavourite]!;
      iconsList.refresh();
    } else {
      iconsList[index] = _iconsCache[FavouriteIcons.favourite]!;
      iconsList.refresh();
      var meal = await _convertCategoryToMeal(category.strMeal);
      _db.insert(meal.copiedObject);
    }
  }

  /// Convert category item to meal object
  Future<Meal> _convertCategoryToMeal(String mealName) async {
    var mealResponse = await RecipeService().getMeal(mealName: mealName);
    return mealResponse.meals[0];
  }

  /// Check if a meal is favorited and update icon
  void checkForFavouriteIcon(String mealId, int index) {
    if (_db.isFavourite(mealId)) {
      iconsList[index] = _iconsCache[FavouriteIcons.favourite]!;
    } else {
      iconsList[index] = _iconsCache[FavouriteIcons.unfavourite]!;
    }
    iconsList.refresh();
  }

  /// Refresh category data
  Future<void> refreshCategory() async {
    if (categoryName.value.isNotEmpty) {
      await loadCategoryData(categoryName.value);
    }
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}