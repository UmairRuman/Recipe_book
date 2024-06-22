import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/meal_services/category_service/category_service.dart';
import 'package:recipe_book/services/meal_services/recipe_service/recipe_service.dart';

class HomePageController extends GetxController {
  HomePageController({required this.selectedNotificationStream});
  final StreamController<String?> selectedNotificationStream;
  var datafetched = false.obs;
  Meal? randomMeal;
  var randomMealReceived = false.obs;
  dynamic categories;
  var favouriteMealsList = <Meal>[];
  var favouritesFetched = false.obs;
  var _pageResponse = 0;

  loadData() async {
    categories = await CategoriesService().fetchCategories();
    datafetched.value = true;
  }

  pushCategoryPage(String categoryName) async {
    favouritesFetched.value = false;
    List<CategoryItem> category =
        await CategoryService().fetchCategory(categoryName);
    _pageResponse =
        await Get.toNamed(CategoryPage.pageAddress, arguments: category);
    if (favouriteMealsList.length != _pageResponse) {
      favouriteMealsList = DBHelper().favouriteMeals();
    }
    favouritesFetched.value = true;
  }

  List<CategoriesModel> getCategoryList() {
    return categories as List<CategoriesModel>;
  }

  getRandomDish() async {
    randomMeal = await RandomReceipeService().getRandomMeal();
    randomMealReceived.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    _selectedNotificationHandler();
    favouriteMealsList = DBHelper().favouriteMeals();
    favouritesFetched.value = true;
  }

  @override
  void onClose() {
    selectedNotificationStream.close();
    super.onClose();
  }

  void _selectedNotificationHandler() {
    selectedNotificationStream.stream.listen(
      (String? payLoad) async {
        payLoad = payLoad!.replaceAll('\n', '\\n').replaceAll('\r', '\\r');
        Map<String, dynamic> meal = jsonDecode(payLoad);
        await Get.toNamed(RecipePage.pageAddress,
            arguments: Meal.fromMap(meal));
      },
    );
  }

  onSuggestionTap(String suggestion) async {
    favouritesFetched.value = false;
    var mealResponse = await RecipeService().getMeal(mealName: suggestion);
    _pageResponse = await Get.toNamed(RecipePage.pageAddress,
        arguments: mealResponse.meals[0].copiedObject);
    if (favouriteMealsList.length != _pageResponse) {
      favouriteMealsList = DBHelper().favouriteMeals();
    }
    favouritesFetched.value = true;
  }

  onMealTap(Meal meal) async {
    favouritesFetched.value = false;
    _pageResponse = await Get.toNamed(RecipePage.pageAddress, arguments: meal);
    if (favouriteMealsList.length != _pageResponse) {
      favouriteMealsList = DBHelper().favouriteMeals();
    }
    favouritesFetched.value = true;
  }
}
