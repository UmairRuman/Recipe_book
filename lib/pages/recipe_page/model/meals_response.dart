// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class MealResponse {
  List<Meal> meals;
  MealResponse({
    required this.meals,
  });

  MealResponse copyWith({
    List<Meal>? meals,
  }) {
    return MealResponse(
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meals': meals.map((x) => x.toMap()).toList(),
    };
  }

  factory MealResponse.fromMap(Map<String, dynamic> map) {
    return MealResponse(
      meals: List<Meal>.from(
        (map['meals'] as List).map<Meal>(
          (x) => Meal.fromMap(x ??
              [
                {
                  'idMeal': '',
                  'strMeal': '',
                  'strDrinkAlternate': '',
                  'strCategory': '',
                  'strArea': '',
                  'strInstructions': '',
                  'strMealThumb': '',
                  'strTags': '',
                  'strYoutube': '',
                  'strIngredient1': '',
                  'strIngredient2': '',
                  'strIngredient3': '',
                  'strIngredient4': '',
                  'strIngredient5': '',
                  'strIngredient6': '',
                  'strIngredient7': '',
                  'strIngredient8': '',
                  'strIngredient9': '',
                  'strIngredient10': '',
                  'strIngredient11': '',
                  'strIngredient12': '',
                  'strIngredient13': '',
                  'strIngredient14': '',
                  'strIngredient15': '',
                  'strIngredient16': '',
                  'strIngredient17': '',
                  'strIngredient18': '',
                  'strIngredient19': '',
                  'strIngredient20': '',
                  'strMeasure1': '',
                  'strMeasure2': '',
                  'strMeasure3': '',
                  'strMeasure4': '',
                  'strMeasure5': '',
                  'strMeasure6': '',
                  'strMeasure7': '',
                  'strMeasure8': '',
                  'strMeasure9': '',
                  'strMeasure10': '',
                  'strMeasure11': '',
                  'strMeasure12': '',
                  'strMeasure13': '',
                  'strMeasure14': '',
                  'strMeasure15': '',
                  'strMeasure16': '',
                  'strMeasure17': '',
                  'strMeasure18': '',
                  'strMeasure19': '',
                  'strMeasure20': '',
                  'strSource': '',
                  'strImageSource': '',
                  'strCreativeCommonsConfirmed': '',
                  'dateModified': '',
                }
              ]),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MealResponse.fromJson(String source) =>
      MealResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MealResponse(meals: $meals)';

  @override
  bool operator ==(covariant MealResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.meals, meals);
  }

  @override
  int get hashCode => meals.hashCode;
}
