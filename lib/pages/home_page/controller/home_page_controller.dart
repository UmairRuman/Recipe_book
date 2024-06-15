import 'dart:async';

import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/pages/recipe_page/model/meals_api_model.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/meal_services/category_service/category_service.dart';
import 'package:recipe_book/services/meal_services/recipe_service/recipe_service.dart';

class HomePageController extends GetxController {
  HomePageController({required this.selectedNotificationStream});
  final StreamController<String?> selectedNotificationStream;
  var datafetched = false.obs;
  MealsModel? randomMeal;
  var randomMealReceived = false.obs;
  dynamic categories;

  loadData() async {
    categories = await CategoriesService().fetchCategories();
    datafetched.value = true;
  }

  pushCategoryPage(String categoryName) async {
    List<CategoryItem> category =
        await CategoryService().fetchCategory(categoryName);
    Get.toNamed(CategoryPage.pageAddress, arguments: category);
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
  }

  @override
  void onClose() {
    selectedNotificationStream.close();
    super.onClose();
  }

  void _selectedNotificationHandler() {
    selectedNotificationStream.stream.listen(
      (String? payLoad) async {
        final RecipeService recipeService = RecipeService();
        var mealResponse = await recipeService.getMeal(mealName: payLoad!);
        await Get.toNamed(RecipePage.pageAddress,
            arguments: mealResponse.meals[0]);
      },
    );
  }
}
