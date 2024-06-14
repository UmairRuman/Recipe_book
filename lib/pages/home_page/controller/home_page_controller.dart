import 'dart:developer';

import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/services/meal_services/category_service.dart';

class HomePageController extends GetxController {
  var datafetched = false.obs;
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
}
