import 'package:recipe_book/pages/recipe_page/model/meals_response.dart';
import 'package:recipe_book/services/meal_services/client.dart';

class RecipeService extends ApiService {
  @override
  String get apiUrl => '/search';

  Future<MealResponse> getMeal({required String mealName}) async {
    String endPoint = '.php?s=$mealName';
    var map = await fetch(endPoint: endPoint);
    return MealResponse.fromMap(map);
  }
}
