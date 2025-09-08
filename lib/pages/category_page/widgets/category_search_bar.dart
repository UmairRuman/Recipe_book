import 'package:flutter/material.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';

class CategorySearchBarWidget extends StatelessWidget {
  const CategorySearchBarWidget({
    super.key,
    required this.categoriesList,
    required this.rebuildFunction,
  });
  final List<CategoryItem> categoriesList;
  final VoidCallback rebuildFunction;

  static const searchCategory = 'Search Meal';

  @override
  Widget build(BuildContext context) {
    // final Size(:height) = MediaQuery.sizeOf(context);
    // final style = TextStyle(
    //     fontSize: height * 0.025,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.black54);
    // final controller = Get.put(AsyncSuggestionsController());
    // final categoryController = Get.find<CategoryController>();

    // Future<void> fetchRecipeSuggestions(String query) async {
    //   controller.isLoading.value = true;

    //   final meals = categoriesList.where(
    //     (element) {
    //       return element.strMeal.toLowerCase().contains(query.toLowerCase());
    //     },
    //   );

    //   List<String> mealNames = meals
    //       .map<String>(
    //         (meal) => meal.strMeal,
    //       )
    //       .toList();

    //   controller
    //       .updateSuggestions(mealNames); // Update suggestions via controller
    //   //Now our suggestion list is ready
    //   controller.isLoading.value = false;
    // }

    // int findIndexOfElement(String value) {
    //   return categoriesList.indexWhere(
    //     (element) => element.strMeal == value,
    //   );
    // }

    // return EasySearchBar(
    //     onSuggestionTap: (value) {
    //       categoryController.navigateToRecipePage(
    //           value, findIndexOfElement(value), rebuildFunction);
    //     },
    //     backgroundColor: Colors.white,
    //     suggestions: controller.suggestions,
    //     isFloating: true,
    //     title: Center(
    //         child: Text(
    //       searchCategory,
    //       style: style,
    //     )),
    //     onSearch: (value) {
    //       if (value.isNotEmpty) {
    //         fetchRecipeSuggestions(value);
    //       }
    //     }
    // );
    return Container();
  }
}
