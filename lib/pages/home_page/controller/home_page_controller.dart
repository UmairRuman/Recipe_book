import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/pages/recipe_page/model/meals_api_model.dart';
import 'package:recipe_book/services/meal_services/category_service/category_service.dart';
import 'package:recipe_book/services/meal_services/recipe_service/recipe_service.dart';

class HomePageController extends GetxController {
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
}
