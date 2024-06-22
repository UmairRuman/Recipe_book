import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Controller/async_suggestions_controller.dart';

class HomeSearchBarWidget extends StatelessWidget {
  const HomeSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const searchHintText = 'Lamb Biryani';
    const searchRecipe = 'Recipe Book';
    final homePageController = Get.find<HomePageController>();
    final controller = Get.put(AsyncSuggestionsController());
    // This is the function for building async Suggestions which we are fetching from API
    Future<void> fetchRecipeSuggestions(String query) async {
      controller.isLoading.value = true;

      final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
      final response = await get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //If the response is successfull then we will assign data['meals']
        //which actully accesses the value associated with the meals key in the data map and assign it to List named meal.
        final List meals = data['meals'] ?? [];

        //Then we map every meal name from the list and convert into a list of String and assign it to our suggestion list.

        List<String> mealNames =
            meals.map<String>((meal) => meal['strMeal'] as String).toList();

        controller
            .updateSuggestions(mealNames); // Update suggestions via controller
        //Now our suggestion list is ready
        controller.isLoading.value = false;
      } else {
        controller.isLoading.value = false;
        throw Exception('Failed to fetch suggestions');
      }
    }

    return EasySearchBar(
      onSuggestionTap: homePageController.onSuggestionTap,
      isFloating: true,
      searchHintText: searchHintText,
      suggestions: controller.suggestions,
      title: const Center(child: Text(searchRecipe)),
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
      onSearch: (value) {
        if (value.isNotEmpty) {
          fetchRecipeSuggestions(value);
        }
      },
    );
  }
}
