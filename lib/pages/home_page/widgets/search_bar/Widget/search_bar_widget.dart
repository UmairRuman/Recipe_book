import 'dart:convert';
import 'dart:developer';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Controller/async_suggestions_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Widget/suggestion_recipe_page.dart';

class HomeSearchBarWidget extends StatefulWidget {
  const HomeSearchBarWidget({super.key});

  @override
  State<HomeSearchBarWidget> createState() => _HomeSearchBarWidgetState();
}

class _HomeSearchBarWidgetState extends State<HomeSearchBarWidget> {
  final AsyncSuggestionsController controller =
      Get.put(AsyncSuggestionsController());

  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return EasySearchBar(
      onSuggestionTap: (data) {
        Get.to(const SuggestionRecipePage(), arguments: data);
      },
      isFloating: true,
      suggestions: controller.suggestions,
      title: const Text("Recipe Search Bar"),
      backgroundColor: Colors.amber,
      titleTextStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      onSearch: (value) {
        controller.searchedText.value = value;
        log("Searched Text : $value");
        if (value.isNotEmpty) {
          fetchRecipeSuggestions(value);
        }
      },
    );
  }
}
