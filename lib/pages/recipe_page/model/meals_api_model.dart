// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MealsModel {
  String idMeal;
  String strMeal;
  String strDrinkAlternate;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String strTags;
  String strYoutube;
  String strIngredient1;
  String strIngredient2;
  String strIngredient3;
  String strIngredient4;
  String strIngredient5;
  String strIngredient6;
  String strIngredient7;
  String strIngredient8;
  String strIngredient9;
  String strIngredient10;
  String strIngredient11;
  String strIngredient12;
  String strIngredient13;
  String strIngredient14;
  String strIngredient15;
  String strIngredient16;
  String strIngredient17;
  String strIngredient18;
  String strIngredient19;
  String strIngredient20;
  String strMeasure1;
  String strMeasure2;
  String strMeasure3;
  String strMeasure4;
  String strMeasure5;
  String strMeasure6;
  String strMeasure7;
  String strMeasure8;
  String strMeasure9;
  String strMeasure10;
  String strMeasure11;
  String strMeasure12;
  String strMeasure13;
  String strMeasure14;
  String strMeasure15;
  String strMeasure16;
  String strMeasure17;
  String strMeasure18;
  String strMeasure19;
  String strMeasure20;
  String strSource;
  String strImageSource;
  String strCreativeCommonsConfirmed;
  String dateModified;
  MealsModel({
    required this.idMeal,
    required this.strMeal,
    required this.strDrinkAlternate,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.strIngredient1,
    required this.strIngredient2,
    required this.strIngredient3,
    required this.strIngredient4,
    required this.strIngredient5,
    required this.strIngredient6,
    required this.strIngredient7,
    required this.strIngredient8,
    required this.strIngredient9,
    required this.strIngredient10,
    required this.strIngredient11,
    required this.strIngredient12,
    required this.strIngredient13,
    required this.strIngredient14,
    required this.strIngredient15,
    required this.strIngredient16,
    required this.strIngredient17,
    required this.strIngredient18,
    required this.strIngredient19,
    required this.strIngredient20,
    required this.strMeasure1,
    required this.strMeasure2,
    required this.strMeasure3,
    required this.strMeasure4,
    required this.strMeasure5,
    required this.strMeasure6,
    required this.strMeasure7,
    required this.strMeasure8,
    required this.strMeasure9,
    required this.strMeasure10,
    required this.strMeasure11,
    required this.strMeasure12,
    required this.strMeasure13,
    required this.strMeasure14,
    required this.strMeasure15,
    required this.strMeasure16,
    required this.strMeasure17,
    required this.strMeasure18,
    required this.strMeasure19,
    required this.strMeasure20,
    required this.strSource,
    required this.strImageSource,
    required this.strCreativeCommonsConfirmed,
    required this.dateModified,
  });

  MealsModel copyWith({
    String? idMeal,
    String? strMeal,
    String? strDrinkAlternate,
    String? strCategory,
    String? strArea,
    String? strInstructions,
    String? strMealThumb,
    String? strTags,
    String? strYoutube,
    String? strIngredient1,
    String? strIngredient2,
    String? strIngredient3,
    String? strIngredient4,
    String? strIngredient5,
    String? strIngredient6,
    String? strIngredient7,
    String? strIngredient8,
    String? strIngredient9,
    String? strIngredient10,
    String? strIngredient11,
    String? strIngredient12,
    String? strIngredient13,
    String? strIngredient14,
    String? strIngredient15,
    String? strIngredient16,
    String? strIngredient17,
    String? strIngredient18,
    String? strIngredient19,
    String? strIngredient20,
    String? strMeasure1,
    String? strMeasure2,
    String? strMeasure3,
    String? strMeasure4,
    String? strMeasure5,
    String? strMeasure6,
    String? strMeasure7,
    String? strMeasure8,
    String? strMeasure9,
    String? strMeasure10,
    String? strMeasure11,
    String? strMeasure12,
    String? strMeasure13,
    String? strMeasure14,
    String? strMeasure15,
    String? strMeasure16,
    String? strMeasure17,
    String? strMeasure18,
    String? strMeasure19,
    String? strMeasure20,
    String? strSource,
    String? strImageSource,
    String? strCreativeCommonsConfirmed,
    String? dateModified,
  }) {
    return MealsModel(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strDrinkAlternate: strDrinkAlternate ?? this.strDrinkAlternate,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strTags: strTags ?? this.strTags,
      strYoutube: strYoutube ?? this.strYoutube,
      strIngredient1: strIngredient1 ?? this.strIngredient1,
      strIngredient2: strIngredient2 ?? this.strIngredient2,
      strIngredient3: strIngredient3 ?? this.strIngredient3,
      strIngredient4: strIngredient4 ?? this.strIngredient4,
      strIngredient5: strIngredient5 ?? this.strIngredient5,
      strIngredient6: strIngredient6 ?? this.strIngredient6,
      strIngredient7: strIngredient7 ?? this.strIngredient7,
      strIngredient8: strIngredient8 ?? this.strIngredient8,
      strIngredient9: strIngredient9 ?? this.strIngredient9,
      strIngredient10: strIngredient10 ?? this.strIngredient10,
      strIngredient11: strIngredient11 ?? this.strIngredient11,
      strIngredient12: strIngredient12 ?? this.strIngredient12,
      strIngredient13: strIngredient13 ?? this.strIngredient13,
      strIngredient14: strIngredient14 ?? this.strIngredient14,
      strIngredient15: strIngredient15 ?? this.strIngredient15,
      strIngredient16: strIngredient16 ?? this.strIngredient16,
      strIngredient17: strIngredient17 ?? this.strIngredient17,
      strIngredient18: strIngredient18 ?? this.strIngredient18,
      strIngredient19: strIngredient19 ?? this.strIngredient19,
      strIngredient20: strIngredient20 ?? this.strIngredient20,
      strMeasure1: strMeasure1 ?? this.strMeasure1,
      strMeasure2: strMeasure2 ?? this.strMeasure2,
      strMeasure3: strMeasure3 ?? this.strMeasure3,
      strMeasure4: strMeasure4 ?? this.strMeasure4,
      strMeasure5: strMeasure5 ?? this.strMeasure5,
      strMeasure6: strMeasure6 ?? this.strMeasure6,
      strMeasure7: strMeasure7 ?? this.strMeasure7,
      strMeasure8: strMeasure8 ?? this.strMeasure8,
      strMeasure9: strMeasure9 ?? this.strMeasure9,
      strMeasure10: strMeasure10 ?? this.strMeasure10,
      strMeasure11: strMeasure11 ?? this.strMeasure11,
      strMeasure12: strMeasure12 ?? this.strMeasure12,
      strMeasure13: strMeasure13 ?? this.strMeasure13,
      strMeasure14: strMeasure14 ?? this.strMeasure14,
      strMeasure15: strMeasure15 ?? this.strMeasure15,
      strMeasure16: strMeasure16 ?? this.strMeasure16,
      strMeasure17: strMeasure17 ?? this.strMeasure17,
      strMeasure18: strMeasure18 ?? this.strMeasure18,
      strMeasure19: strMeasure19 ?? this.strMeasure19,
      strMeasure20: strMeasure20 ?? this.strMeasure20,
      strSource: strSource ?? this.strSource,
      strImageSource: strImageSource ?? this.strImageSource,
      strCreativeCommonsConfirmed:
          strCreativeCommonsConfirmed ?? this.strCreativeCommonsConfirmed,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strDrinkAlternate': strDrinkAlternate,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strIngredient1': strIngredient1,
      'strIngredient2': strIngredient2,
      'strIngredient3': strIngredient3,
      'strIngredient4': strIngredient4,
      'strIngredient5': strIngredient5,
      'strIngredient6': strIngredient6,
      'strIngredient7': strIngredient7,
      'strIngredient8': strIngredient8,
      'strIngredient9': strIngredient9,
      'strIngredient10': strIngredient10,
      'strIngredient11': strIngredient11,
      'strIngredient12': strIngredient12,
      'strIngredient13': strIngredient13,
      'strIngredient14': strIngredient14,
      'strIngredient15': strIngredient15,
      'strIngredient16': strIngredient16,
      'strIngredient17': strIngredient17,
      'strIngredient18': strIngredient18,
      'strIngredient19': strIngredient19,
      'strIngredient20': strIngredient20,
      'strMeasure1': strMeasure1,
      'strMeasure2': strMeasure2,
      'strMeasure3': strMeasure3,
      'strMeasure4': strMeasure4,
      'strMeasure5': strMeasure5,
      'strMeasure6': strMeasure6,
      'strMeasure7': strMeasure7,
      'strMeasure8': strMeasure8,
      'strMeasure9': strMeasure9,
      'strMeasure10': strMeasure10,
      'strMeasure11': strMeasure11,
      'strMeasure12': strMeasure12,
      'strMeasure13': strMeasure13,
      'strMeasure14': strMeasure14,
      'strMeasure15': strMeasure15,
      'strMeasure16': strMeasure16,
      'strMeasure17': strMeasure17,
      'strMeasure18': strMeasure18,
      'strMeasure19': strMeasure19,
      'strMeasure20': strMeasure20,
      'strSource': strSource,
      'strImageSource': strImageSource,
      'strCreativeCommonsConfirmed': strCreativeCommonsConfirmed,
      'dateModified': dateModified,
    };
  }

  factory MealsModel.fromMap(Map<String, dynamic> map) {
    return MealsModel(
      idMeal: map['idMeal'] ?? '',
      strMeal: map['strMeal'] ?? '',
      strDrinkAlternate: map['strDrinkAlternate'] ?? '',
      strCategory: map['strCategory'] ?? '',
      strArea: map['strArea'] ?? '',
      strInstructions: map['strInstructions'] ?? '',
      strMealThumb: map['strMealThumb'] ?? '',
      strTags: map['strTags'] ?? '',
      strYoutube: map['strYoutube'] ?? '',
      strIngredient1: map['strIngredient1'] ?? '',
      strIngredient2: map['strIngredient2'] ?? '',
      strIngredient3: map['strIngredient3'] ?? '',
      strIngredient4: map['strIngredient4'] ?? '',
      strIngredient5: map['strIngredient5'] ?? '',
      strIngredient6: map['strIngredient6'] ?? '',
      strIngredient7: map['strIngredient7'] ?? '',
      strIngredient8: map['strIngredient8'] ?? '',
      strIngredient9: map['strIngredient9'] ?? '',
      strIngredient10: map['strIngredient10'] ?? '',
      strIngredient11: map['strIngredient11'] ?? '',
      strIngredient12: map['strIngredient12'] ?? '',
      strIngredient13: map['strIngredient13'] ?? '',
      strIngredient14: map['strIngredient14'] ?? '',
      strIngredient15: map['strIngredient15'] ?? '',
      strIngredient16: map['strIngredient16'] ?? '',
      strIngredient17: map['strIngredient17'] ?? '',
      strIngredient18: map['strIngredient18'] ?? '',
      strIngredient19: map['strIngredient19'] ?? '',
      strIngredient20: map['strIngredient20'] ?? '',
      strMeasure1: map['strMeasure1'] ?? '',
      strMeasure2: map['strMeasure2'] ?? '',
      strMeasure3: map['strMeasure3'] ?? '',
      strMeasure4: map['strMeasure4'] ?? '',
      strMeasure5: map['strMeasure5'] ?? '',
      strMeasure6: map['strMeasure6'] ?? '',
      strMeasure7: map['strMeasure7'] ?? '',
      strMeasure8: map['strMeasure8'] ?? '',
      strMeasure9: map['strMeasure9'] ?? '',
      strMeasure10: map['strMeasure10'] ?? '',
      strMeasure11: map['strMeasure11'] ?? '',
      strMeasure12: map['strMeasure12'] ?? '',
      strMeasure13: map['strMeasure13'] ?? '',
      strMeasure14: map['strMeasure14'] ?? '',
      strMeasure15: map['strMeasure15'] ?? '',
      strMeasure16: map['strMeasure16'] ?? '',
      strMeasure17: map['strMeasure17'] ?? '',
      strMeasure18: map['strMeasure18'] ?? '',
      strMeasure19: map['strMeasure19'] ?? '',
      strMeasure20: map['strMeasure20'] ?? '',
      strSource: map['strSource'] ?? '',
      strImageSource: map['strImageSource'] ?? '',
      strCreativeCommonsConfirmed: map['strCreativeCommonsConfirmed'] ?? '',
      dateModified: map['dateModified'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MealsModel.fromJson(String source) =>
      MealsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecipeModel(idMeal: $idMeal, strMeal: $strMeal, strDrinkAlternate: $strDrinkAlternate, strCategory: $strCategory, strArea: $strArea, strInstructions: $strInstructions, strMealThumb: $strMealThumb, strTags: $strTags, strYoutube: $strYoutube, strIngredient1: $strIngredient1, strIngredient2: $strIngredient2, strIngredient3: $strIngredient3, strIngredient4: $strIngredient4, strIngredient5: $strIngredient5, strIngredient6: $strIngredient6, strIngredient7: $strIngredient7, strIngredient8: $strIngredient8, strIngredient9: $strIngredient9, strIngredient10: $strIngredient10, strIngredient11: $strIngredient11, strIngredient12: $strIngredient12, strIngredient13: $strIngredient13, strIngredient14: $strIngredient14, strIngredient15: $strIngredient15, strIngredient16: $strIngredient16, strIngredient17: $strIngredient17, strIngredient18: $strIngredient18, strIngredient19: $strIngredient19, strIngredient20: $strIngredient20, strMeasure1: $strMeasure1, strMeasure2: $strMeasure2, strMeasure3: $strMeasure3, strMeasure4: $strMeasure4, strMeasure5: $strMeasure5, strMeasure6: $strMeasure6, strMeasure7: $strMeasure7, strMeasure8: $strMeasure8, strMeasure9: $strMeasure9, strMeasure10: $strMeasure10, strMeasure11: $strMeasure11, strMeasure12: $strMeasure12, strMeasure13: $strMeasure13, strMeasure14: $strMeasure14, strMeasure15: $strMeasure15, strMeasure16: $strMeasure16, strMeasure17: $strMeasure17, strMeasure18: $strMeasure18, strMeasure19: $strMeasure19, strMeasure20: $strMeasure20, strSource: $strSource, strImageSource: $strImageSource, strCreativeCommonsConfirmed: $strCreativeCommonsConfirmed, dateModified: $dateModified)';
  }

  @override
  bool operator ==(covariant MealsModel other) {
    if (identical(this, other)) return true;

    return other.idMeal == idMeal &&
        other.strMeal == strMeal &&
        other.strDrinkAlternate == strDrinkAlternate &&
        other.strCategory == strCategory &&
        other.strArea == strArea &&
        other.strInstructions == strInstructions &&
        other.strMealThumb == strMealThumb &&
        other.strTags == strTags &&
        other.strYoutube == strYoutube &&
        other.strIngredient1 == strIngredient1 &&
        other.strIngredient2 == strIngredient2 &&
        other.strIngredient3 == strIngredient3 &&
        other.strIngredient4 == strIngredient4 &&
        other.strIngredient5 == strIngredient5 &&
        other.strIngredient6 == strIngredient6 &&
        other.strIngredient7 == strIngredient7 &&
        other.strIngredient8 == strIngredient8 &&
        other.strIngredient9 == strIngredient9 &&
        other.strIngredient10 == strIngredient10 &&
        other.strIngredient11 == strIngredient11 &&
        other.strIngredient12 == strIngredient12 &&
        other.strIngredient13 == strIngredient13 &&
        other.strIngredient14 == strIngredient14 &&
        other.strIngredient15 == strIngredient15 &&
        other.strIngredient16 == strIngredient16 &&
        other.strIngredient17 == strIngredient17 &&
        other.strIngredient18 == strIngredient18 &&
        other.strIngredient19 == strIngredient19 &&
        other.strIngredient20 == strIngredient20 &&
        other.strMeasure1 == strMeasure1 &&
        other.strMeasure2 == strMeasure2 &&
        other.strMeasure3 == strMeasure3 &&
        other.strMeasure4 == strMeasure4 &&
        other.strMeasure5 == strMeasure5 &&
        other.strMeasure6 == strMeasure6 &&
        other.strMeasure7 == strMeasure7 &&
        other.strMeasure8 == strMeasure8 &&
        other.strMeasure9 == strMeasure9 &&
        other.strMeasure10 == strMeasure10 &&
        other.strMeasure11 == strMeasure11 &&
        other.strMeasure12 == strMeasure12 &&
        other.strMeasure13 == strMeasure13 &&
        other.strMeasure14 == strMeasure14 &&
        other.strMeasure15 == strMeasure15 &&
        other.strMeasure16 == strMeasure16 &&
        other.strMeasure17 == strMeasure17 &&
        other.strMeasure18 == strMeasure18 &&
        other.strMeasure19 == strMeasure19 &&
        other.strMeasure20 == strMeasure20 &&
        other.strSource == strSource &&
        other.strImageSource == strImageSource &&
        other.strCreativeCommonsConfirmed == strCreativeCommonsConfirmed &&
        other.dateModified == dateModified;
  }

  @override
  int get hashCode {
    return idMeal.hashCode ^
        strMeal.hashCode ^
        strDrinkAlternate.hashCode ^
        strCategory.hashCode ^
        strArea.hashCode ^
        strInstructions.hashCode ^
        strMealThumb.hashCode ^
        strTags.hashCode ^
        strYoutube.hashCode ^
        strIngredient1.hashCode ^
        strIngredient2.hashCode ^
        strIngredient3.hashCode ^
        strIngredient4.hashCode ^
        strIngredient5.hashCode ^
        strIngredient6.hashCode ^
        strIngredient7.hashCode ^
        strIngredient8.hashCode ^
        strIngredient9.hashCode ^
        strIngredient10.hashCode ^
        strIngredient11.hashCode ^
        strIngredient12.hashCode ^
        strIngredient13.hashCode ^
        strIngredient14.hashCode ^
        strIngredient15.hashCode ^
        strIngredient16.hashCode ^
        strIngredient17.hashCode ^
        strIngredient18.hashCode ^
        strIngredient19.hashCode ^
        strIngredient20.hashCode ^
        strMeasure1.hashCode ^
        strMeasure2.hashCode ^
        strMeasure3.hashCode ^
        strMeasure4.hashCode ^
        strMeasure5.hashCode ^
        strMeasure6.hashCode ^
        strMeasure7.hashCode ^
        strMeasure8.hashCode ^
        strMeasure9.hashCode ^
        strMeasure10.hashCode ^
        strMeasure11.hashCode ^
        strMeasure12.hashCode ^
        strMeasure13.hashCode ^
        strMeasure14.hashCode ^
        strMeasure15.hashCode ^
        strMeasure16.hashCode ^
        strMeasure17.hashCode ^
        strMeasure18.hashCode ^
        strMeasure19.hashCode ^
        strMeasure20.hashCode ^
        strSource.hashCode ^
        strImageSource.hashCode ^
        strCreativeCommonsConfirmed.hashCode ^
        dateModified.hashCode;
  }
}
