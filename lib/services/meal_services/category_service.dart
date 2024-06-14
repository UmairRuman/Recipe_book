import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/services/meal_services/client.dart';

class CategoriesService extends ApiService {
  @override
  String get apiUrl => '/categories.php';

  Future<List<CategoriesModel>> fetchCategories() async {
    Map<String, dynamic> categoriesMap = await fetch();
    List<dynamic>? listOfMap = categoriesMap['categories'];

    return listOfMap!.map((map) => CategoriesModel.fromMap(map)).toList();
  }
}

class CategoryService extends ApiService {
  @override
  String get apiUrl => '/filter.php?c=';

  Future<List<CategoryItem>> fetchCategory(String category) async {
    Map<String, dynamic> categoryMap = await fetch(endPoint: category);
    List<dynamic>? listOfMap = categoryMap['meals'];

    return listOfMap!.map((map) => CategoryItem.fromMap(map)).toList();
  }
}
