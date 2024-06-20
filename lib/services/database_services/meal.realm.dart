// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Meal extends _Meal with RealmEntity, RealmObjectBase, RealmObject {
  Meal({
    required String idMeal,
    required String strMeal,
    required String strCategory,
    required String strArea,
    required String strInstructions,
    required String strMealThumb,
    required String strYoutube,
    String? strDrinkAlternate,
    String? strTags,
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
    RealmObjectBase.set(this, 'idMeal', idMeal);
    RealmObjectBase.set(this, 'strMeal', strMeal);
    RealmObjectBase.set(this, 'strDrinkAlternate', strDrinkAlternate);
    RealmObjectBase.set(this, 'strCategory', strCategory);
    RealmObjectBase.set(this, 'strArea', strArea);
    RealmObjectBase.set(this, 'strInstructions', strInstructions);
    RealmObjectBase.set(this, 'strMealThumb', strMealThumb);
    RealmObjectBase.set(this, 'strTags', strTags);
    RealmObjectBase.set(this, 'strYoutube', strYoutube);
    RealmObjectBase.set(this, 'strIngredient1', strIngredient1);
    RealmObjectBase.set(this, 'strIngredient2', strIngredient2);
    RealmObjectBase.set(this, 'strIngredient3', strIngredient3);
    RealmObjectBase.set(this, 'strIngredient4', strIngredient4);
    RealmObjectBase.set(this, 'strIngredient5', strIngredient5);
    RealmObjectBase.set(this, 'strIngredient6', strIngredient6);
    RealmObjectBase.set(this, 'strIngredient7', strIngredient7);
    RealmObjectBase.set(this, 'strIngredient8', strIngredient8);
    RealmObjectBase.set(this, 'strIngredient9', strIngredient9);
    RealmObjectBase.set(this, 'strIngredient10', strIngredient10);
    RealmObjectBase.set(this, 'strIngredient11', strIngredient11);
    RealmObjectBase.set(this, 'strIngredient12', strIngredient12);
    RealmObjectBase.set(this, 'strIngredient13', strIngredient13);
    RealmObjectBase.set(this, 'strIngredient14', strIngredient14);
    RealmObjectBase.set(this, 'strIngredient15', strIngredient15);
    RealmObjectBase.set(this, 'strIngredient16', strIngredient16);
    RealmObjectBase.set(this, 'strIngredient17', strIngredient17);
    RealmObjectBase.set(this, 'strIngredient18', strIngredient18);
    RealmObjectBase.set(this, 'strIngredient19', strIngredient19);
    RealmObjectBase.set(this, 'strIngredient20', strIngredient20);
    RealmObjectBase.set(this, 'strMeasure1', strMeasure1);
    RealmObjectBase.set(this, 'strMeasure2', strMeasure2);
    RealmObjectBase.set(this, 'strMeasure3', strMeasure3);
    RealmObjectBase.set(this, 'strMeasure4', strMeasure4);
    RealmObjectBase.set(this, 'strMeasure5', strMeasure5);
    RealmObjectBase.set(this, 'strMeasure6', strMeasure6);
    RealmObjectBase.set(this, 'strMeasure7', strMeasure7);
    RealmObjectBase.set(this, 'strMeasure8', strMeasure8);
    RealmObjectBase.set(this, 'strMeasure9', strMeasure9);
    RealmObjectBase.set(this, 'strMeasure10', strMeasure10);
    RealmObjectBase.set(this, 'strMeasure11', strMeasure11);
    RealmObjectBase.set(this, 'strMeasure12', strMeasure12);
    RealmObjectBase.set(this, 'strMeasure13', strMeasure13);
    RealmObjectBase.set(this, 'strMeasure14', strMeasure14);
    RealmObjectBase.set(this, 'strMeasure15', strMeasure15);
    RealmObjectBase.set(this, 'strMeasure16', strMeasure16);
    RealmObjectBase.set(this, 'strMeasure17', strMeasure17);
    RealmObjectBase.set(this, 'strMeasure18', strMeasure18);
    RealmObjectBase.set(this, 'strMeasure19', strMeasure19);
    RealmObjectBase.set(this, 'strMeasure20', strMeasure20);
    RealmObjectBase.set(this, 'strSource', strSource);
    RealmObjectBase.set(this, 'strImageSource', strImageSource);
    RealmObjectBase.set(
        this, 'strCreativeCommonsConfirmed', strCreativeCommonsConfirmed);
    RealmObjectBase.set(this, 'dateModified', dateModified);
  }

  Meal._();

  @override
  String get idMeal => RealmObjectBase.get<String>(this, 'idMeal') as String;
  @override
  set idMeal(String value) => RealmObjectBase.set(this, 'idMeal', value);

  @override
  String get strMeal => RealmObjectBase.get<String>(this, 'strMeal') as String;
  @override
  set strMeal(String value) => RealmObjectBase.set(this, 'strMeal', value);

  @override
  String? get strDrinkAlternate =>
      RealmObjectBase.get<String>(this, 'strDrinkAlternate') as String?;
  @override
  set strDrinkAlternate(String? value) =>
      RealmObjectBase.set(this, 'strDrinkAlternate', value);

  @override
  String get strCategory =>
      RealmObjectBase.get<String>(this, 'strCategory') as String;
  @override
  set strCategory(String value) =>
      RealmObjectBase.set(this, 'strCategory', value);

  @override
  String get strArea => RealmObjectBase.get<String>(this, 'strArea') as String;
  @override
  set strArea(String value) => RealmObjectBase.set(this, 'strArea', value);

  @override
  String get strInstructions =>
      RealmObjectBase.get<String>(this, 'strInstructions') as String;
  @override
  set strInstructions(String value) =>
      RealmObjectBase.set(this, 'strInstructions', value);

  @override
  String get strMealThumb =>
      RealmObjectBase.get<String>(this, 'strMealThumb') as String;
  @override
  set strMealThumb(String value) =>
      RealmObjectBase.set(this, 'strMealThumb', value);

  @override
  String? get strTags =>
      RealmObjectBase.get<String>(this, 'strTags') as String?;
  @override
  set strTags(String? value) => RealmObjectBase.set(this, 'strTags', value);

  @override
  String get strYoutube =>
      RealmObjectBase.get<String>(this, 'strYoutube') as String;
  @override
  set strYoutube(String value) =>
      RealmObjectBase.set(this, 'strYoutube', value);

  @override
  String? get strIngredient1 =>
      RealmObjectBase.get<String>(this, 'strIngredient1') as String?;
  @override
  set strIngredient1(String? value) =>
      RealmObjectBase.set(this, 'strIngredient1', value);

  @override
  String? get strIngredient2 =>
      RealmObjectBase.get<String>(this, 'strIngredient2') as String?;
  @override
  set strIngredient2(String? value) =>
      RealmObjectBase.set(this, 'strIngredient2', value);

  @override
  String? get strIngredient3 =>
      RealmObjectBase.get<String>(this, 'strIngredient3') as String?;
  @override
  set strIngredient3(String? value) =>
      RealmObjectBase.set(this, 'strIngredient3', value);

  @override
  String? get strIngredient4 =>
      RealmObjectBase.get<String>(this, 'strIngredient4') as String?;
  @override
  set strIngredient4(String? value) =>
      RealmObjectBase.set(this, 'strIngredient4', value);

  @override
  String? get strIngredient5 =>
      RealmObjectBase.get<String>(this, 'strIngredient5') as String?;
  @override
  set strIngredient5(String? value) =>
      RealmObjectBase.set(this, 'strIngredient5', value);

  @override
  String? get strIngredient6 =>
      RealmObjectBase.get<String>(this, 'strIngredient6') as String?;
  @override
  set strIngredient6(String? value) =>
      RealmObjectBase.set(this, 'strIngredient6', value);

  @override
  String? get strIngredient7 =>
      RealmObjectBase.get<String>(this, 'strIngredient7') as String?;
  @override
  set strIngredient7(String? value) =>
      RealmObjectBase.set(this, 'strIngredient7', value);

  @override
  String? get strIngredient8 =>
      RealmObjectBase.get<String>(this, 'strIngredient8') as String?;
  @override
  set strIngredient8(String? value) =>
      RealmObjectBase.set(this, 'strIngredient8', value);

  @override
  String? get strIngredient9 =>
      RealmObjectBase.get<String>(this, 'strIngredient9') as String?;
  @override
  set strIngredient9(String? value) =>
      RealmObjectBase.set(this, 'strIngredient9', value);

  @override
  String? get strIngredient10 =>
      RealmObjectBase.get<String>(this, 'strIngredient10') as String?;
  @override
  set strIngredient10(String? value) =>
      RealmObjectBase.set(this, 'strIngredient10', value);

  @override
  String? get strIngredient11 =>
      RealmObjectBase.get<String>(this, 'strIngredient11') as String?;
  @override
  set strIngredient11(String? value) =>
      RealmObjectBase.set(this, 'strIngredient11', value);

  @override
  String? get strIngredient12 =>
      RealmObjectBase.get<String>(this, 'strIngredient12') as String?;
  @override
  set strIngredient12(String? value) =>
      RealmObjectBase.set(this, 'strIngredient12', value);

  @override
  String? get strIngredient13 =>
      RealmObjectBase.get<String>(this, 'strIngredient13') as String?;
  @override
  set strIngredient13(String? value) =>
      RealmObjectBase.set(this, 'strIngredient13', value);

  @override
  String? get strIngredient14 =>
      RealmObjectBase.get<String>(this, 'strIngredient14') as String?;
  @override
  set strIngredient14(String? value) =>
      RealmObjectBase.set(this, 'strIngredient14', value);

  @override
  String? get strIngredient15 =>
      RealmObjectBase.get<String>(this, 'strIngredient15') as String?;
  @override
  set strIngredient15(String? value) =>
      RealmObjectBase.set(this, 'strIngredient15', value);

  @override
  String? get strIngredient16 =>
      RealmObjectBase.get<String>(this, 'strIngredient16') as String?;
  @override
  set strIngredient16(String? value) =>
      RealmObjectBase.set(this, 'strIngredient16', value);

  @override
  String? get strIngredient17 =>
      RealmObjectBase.get<String>(this, 'strIngredient17') as String?;
  @override
  set strIngredient17(String? value) =>
      RealmObjectBase.set(this, 'strIngredient17', value);

  @override
  String? get strIngredient18 =>
      RealmObjectBase.get<String>(this, 'strIngredient18') as String?;
  @override
  set strIngredient18(String? value) =>
      RealmObjectBase.set(this, 'strIngredient18', value);

  @override
  String? get strIngredient19 =>
      RealmObjectBase.get<String>(this, 'strIngredient19') as String?;
  @override
  set strIngredient19(String? value) =>
      RealmObjectBase.set(this, 'strIngredient19', value);

  @override
  String? get strIngredient20 =>
      RealmObjectBase.get<String>(this, 'strIngredient20') as String?;
  @override
  set strIngredient20(String? value) =>
      RealmObjectBase.set(this, 'strIngredient20', value);

  @override
  String? get strMeasure1 =>
      RealmObjectBase.get<String>(this, 'strMeasure1') as String?;
  @override
  set strMeasure1(String? value) =>
      RealmObjectBase.set(this, 'strMeasure1', value);

  @override
  String? get strMeasure2 =>
      RealmObjectBase.get<String>(this, 'strMeasure2') as String?;
  @override
  set strMeasure2(String? value) =>
      RealmObjectBase.set(this, 'strMeasure2', value);

  @override
  String? get strMeasure3 =>
      RealmObjectBase.get<String>(this, 'strMeasure3') as String?;
  @override
  set strMeasure3(String? value) =>
      RealmObjectBase.set(this, 'strMeasure3', value);

  @override
  String? get strMeasure4 =>
      RealmObjectBase.get<String>(this, 'strMeasure4') as String?;
  @override
  set strMeasure4(String? value) =>
      RealmObjectBase.set(this, 'strMeasure4', value);

  @override
  String? get strMeasure5 =>
      RealmObjectBase.get<String>(this, 'strMeasure5') as String?;
  @override
  set strMeasure5(String? value) =>
      RealmObjectBase.set(this, 'strMeasure5', value);

  @override
  String? get strMeasure6 =>
      RealmObjectBase.get<String>(this, 'strMeasure6') as String?;
  @override
  set strMeasure6(String? value) =>
      RealmObjectBase.set(this, 'strMeasure6', value);

  @override
  String? get strMeasure7 =>
      RealmObjectBase.get<String>(this, 'strMeasure7') as String?;
  @override
  set strMeasure7(String? value) =>
      RealmObjectBase.set(this, 'strMeasure7', value);

  @override
  String? get strMeasure8 =>
      RealmObjectBase.get<String>(this, 'strMeasure8') as String?;
  @override
  set strMeasure8(String? value) =>
      RealmObjectBase.set(this, 'strMeasure8', value);

  @override
  String? get strMeasure9 =>
      RealmObjectBase.get<String>(this, 'strMeasure9') as String?;
  @override
  set strMeasure9(String? value) =>
      RealmObjectBase.set(this, 'strMeasure9', value);

  @override
  String? get strMeasure10 =>
      RealmObjectBase.get<String>(this, 'strMeasure10') as String?;
  @override
  set strMeasure10(String? value) =>
      RealmObjectBase.set(this, 'strMeasure10', value);

  @override
  String? get strMeasure11 =>
      RealmObjectBase.get<String>(this, 'strMeasure11') as String?;
  @override
  set strMeasure11(String? value) =>
      RealmObjectBase.set(this, 'strMeasure11', value);

  @override
  String? get strMeasure12 =>
      RealmObjectBase.get<String>(this, 'strMeasure12') as String?;
  @override
  set strMeasure12(String? value) =>
      RealmObjectBase.set(this, 'strMeasure12', value);

  @override
  String? get strMeasure13 =>
      RealmObjectBase.get<String>(this, 'strMeasure13') as String?;
  @override
  set strMeasure13(String? value) =>
      RealmObjectBase.set(this, 'strMeasure13', value);

  @override
  String? get strMeasure14 =>
      RealmObjectBase.get<String>(this, 'strMeasure14') as String?;
  @override
  set strMeasure14(String? value) =>
      RealmObjectBase.set(this, 'strMeasure14', value);

  @override
  String? get strMeasure15 =>
      RealmObjectBase.get<String>(this, 'strMeasure15') as String?;
  @override
  set strMeasure15(String? value) =>
      RealmObjectBase.set(this, 'strMeasure15', value);

  @override
  String? get strMeasure16 =>
      RealmObjectBase.get<String>(this, 'strMeasure16') as String?;
  @override
  set strMeasure16(String? value) =>
      RealmObjectBase.set(this, 'strMeasure16', value);

  @override
  String? get strMeasure17 =>
      RealmObjectBase.get<String>(this, 'strMeasure17') as String?;
  @override
  set strMeasure17(String? value) =>
      RealmObjectBase.set(this, 'strMeasure17', value);

  @override
  String? get strMeasure18 =>
      RealmObjectBase.get<String>(this, 'strMeasure18') as String?;
  @override
  set strMeasure18(String? value) =>
      RealmObjectBase.set(this, 'strMeasure18', value);

  @override
  String? get strMeasure19 =>
      RealmObjectBase.get<String>(this, 'strMeasure19') as String?;
  @override
  set strMeasure19(String? value) =>
      RealmObjectBase.set(this, 'strMeasure19', value);

  @override
  String? get strMeasure20 =>
      RealmObjectBase.get<String>(this, 'strMeasure20') as String?;
  @override
  set strMeasure20(String? value) =>
      RealmObjectBase.set(this, 'strMeasure20', value);

  @override
  String? get strSource =>
      RealmObjectBase.get<String>(this, 'strSource') as String?;
  @override
  set strSource(String? value) => RealmObjectBase.set(this, 'strSource', value);

  @override
  String? get strImageSource =>
      RealmObjectBase.get<String>(this, 'strImageSource') as String?;
  @override
  set strImageSource(String? value) =>
      RealmObjectBase.set(this, 'strImageSource', value);

  @override
  String? get strCreativeCommonsConfirmed =>
      RealmObjectBase.get<String>(this, 'strCreativeCommonsConfirmed')
          as String?;
  @override
  set strCreativeCommonsConfirmed(String? value) =>
      RealmObjectBase.set(this, 'strCreativeCommonsConfirmed', value);

  @override
  String? get dateModified =>
      RealmObjectBase.get<String>(this, 'dateModified') as String?;
  @override
  set dateModified(String? value) =>
      RealmObjectBase.set(this, 'dateModified', value);

  @override
  Stream<RealmObjectChanges<Meal>> get changes =>
      RealmObjectBase.getChanges<Meal>(this);

  @override
  Stream<RealmObjectChanges<Meal>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Meal>(this, keyPaths);

  @override
  Meal freeze() => RealmObjectBase.freezeObject<Meal>(this);

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      idMeal: map['idMeal'],
      strMeal: map['strMeal'],
      strCategory: map['strCategory'],
      strArea: map['strArea'],
      strInstructions: map['strInstructions'],
      strMealThumb: map['strMealThumb'],
      strYoutube: map['strYoutube'],
      dateModified: map['dateModified'],
      strCreativeCommonsConfirmed: map['strCreativeCommonsConfirmed'],
      strDrinkAlternate: map['strDrinkAlternate'],
      strImageSource: map['strImageSource'],
      strSource: map['strSource'],
      strTags: map['strTags'],
      strIngredient1: map['strIngredient1'],
      strIngredient2: map['strIngredient2'],
      strIngredient3: map['strIngredient3'],
      strIngredient4: map['strIngredient4'],
      strIngredient5: map['strIngredient5'],
      strIngredient6: map['strIngredient6'],
      strIngredient7: map['strIngredient7'],
      strIngredient8: map['strIngredient8'],
      strIngredient9: map['strIngredient9'],
      strIngredient10: map['strIngredient10'],
      strIngredient11: map['strIngredient11'],
      strIngredient12: map['strIngredient12'],
      strIngredient13: map['strIngredient13'],
      strIngredient14: map['strIngredient14'],
      strIngredient15: map['strIngredient15'],
      strIngredient16: map['strIngredient16'],
      strIngredient17: map['strIngredient17'],
      strIngredient18: map['strIngredient18'],
      strIngredient19: map['strIngredient19'],
      strIngredient20: map['strIngredient20'],
      strMeasure1: map['strMeasure1'],
      strMeasure2: map['strMeasure2'],
      strMeasure3: map['strMeasure3'],
      strMeasure4: map['strMeasure4'],
      strMeasure5: map['strMeasure5'],
      strMeasure6: map['strMeasure6'],
      strMeasure7: map['strMeasure7'],
      strMeasure8: map['strMeasure8'],
      strMeasure9: map['strMeasure9'],
      strMeasure10: map['strMeasure10'],
      strMeasure11: map['strMeasure11'],
      strMeasure12: map['strMeasure12'],
      strMeasure13: map['strMeasure13'],
      strMeasure14: map['strMeasure14'],
      strMeasure15: map['strMeasure15'],
      strMeasure16: map['strMeasure16'],
      strMeasure17: map['strMeasure17'],
      strMeasure18: map['strMeasure18'],
      strMeasure19: map['strMeasure19'],
      strMeasure20: map['strMeasure20'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '"idMeal"': '"$idMeal"',
      '"strMeal"': '"$strMeal"',
      '"strDrinkAlternate"': '"$strDrinkAlternate"',
      '"strCategory"': '"$strCategory"',
      '"strArea"': '"$strArea"',
      '"strInstructions"': '"$strInstructions"',
      '"strMealThumb"': '"$strMealThumb"',
      '"strTags"': '"$strTags"',
      '"strYoutube"': '"$strYoutube"',
      '"strIngredient1"': '"$strIngredient1"',
      '"strIngredient2"': '"$strIngredient2"',
      '"strIngredient3"': '"$strIngredient3"',
      '"strIngredient4"': '"$strIngredient4"',
      '"strIngredient5"': '"$strIngredient5"',
      '"strIngredient6"': '"$strIngredient6"',
      '"strIngredient7"': '"$strIngredient7"',
      '"strIngredient8"': '"$strIngredient8"',
      '"strIngredient9"': '"$strIngredient9"',
      '"strIngredient10"': '"$strIngredient10"',
      '"strIngredient11"': '"$strIngredient11"',
      '"strIngredient12"': '"$strIngredient12"',
      '"strIngredient13"': '"$strIngredient13"',
      '"strIngredient14"': '"$strIngredient14"',
      '"strIngredient15"': '"$strIngredient15"',
      '"strIngredient16"': '"$strIngredient16"',
      '"strIngredient17"': '"$strIngredient17"',
      '"strIngredient18"': '"$strIngredient18"',
      '"strIngredient19"': '"$strIngredient19"',
      '"strIngredient20"': '"$strIngredient20"',
      '"strMeasure1"': '"$strMeasure1"',
      '"strMeasure2"': '"$strMeasure2"',
      '"strMeasure3"': '"$strMeasure3"',
      '"strMeasure4"': '"$strMeasure4"',
      '"strMeasure5"': '"$strMeasure5"',
      '"strMeasure6"': '"$strMeasure6"',
      '"strMeasure7"': '"$strMeasure7"',
      '"strMeasure8"': '"$strMeasure8"',
      '"strMeasure9"': '"$strMeasure9"',
      '"strMeasure10"': '"$strMeasure10"',
      '"strMeasure11"': '"$strMeasure11"',
      '"strMeasure12"': '"$strMeasure12"',
      '"strMeasure13"': '"$strMeasure13"',
      '"strMeasure14"': '"$strMeasure14"',
      '"strMeasure15"': '"$strMeasure15"',
      '"strMeasure16"': '"$strMeasure16"',
      '"strMeasure17"': '"$strMeasure17"',
      '"strMeasure18"': '"$strMeasure18"',
      '"strMeasure19"': '"$strMeasure19"',
      '"strMeasure20"': '"$strMeasure20"',
      '"strSource"': '"$strSource"',
      '"strImageSource"': '"$strImageSource"',
      '"strCreativeCommonsConfirmed"': '"$strCreativeCommonsConfirmed"',
      '"dateModified"': '"$dateModified"',
    };
  }

  EJsonValue toEJson() {
    return <String, dynamic>{
      'idMeal': idMeal.toEJson(),
      'strMeal': strMeal.toEJson(),
      'strDrinkAlternate': strDrinkAlternate.toEJson(),
      'strCategory': strCategory.toEJson(),
      'strArea': strArea.toEJson(),
      'strInstructions': strInstructions.toEJson(),
      'strMealThumb': strMealThumb.toEJson(),
      'strTags': strTags.toEJson(),
      'strYoutube': strYoutube.toEJson(),
      'strIngredient1': strIngredient1.toEJson(),
      'strIngredient2': strIngredient2.toEJson(),
      'strIngredient3': strIngredient3.toEJson(),
      'strIngredient4': strIngredient4.toEJson(),
      'strIngredient5': strIngredient5.toEJson(),
      'strIngredient6': strIngredient6.toEJson(),
      'strIngredient7': strIngredient7.toEJson(),
      'strIngredient8': strIngredient8.toEJson(),
      'strIngredient9': strIngredient9.toEJson(),
      'strIngredient10': strIngredient10.toEJson(),
      'strIngredient11': strIngredient11.toEJson(),
      'strIngredient12': strIngredient12.toEJson(),
      'strIngredient13': strIngredient13.toEJson(),
      'strIngredient14': strIngredient14.toEJson(),
      'strIngredient15': strIngredient15.toEJson(),
      'strIngredient16': strIngredient16.toEJson(),
      'strIngredient17': strIngredient17.toEJson(),
      'strIngredient18': strIngredient18.toEJson(),
      'strIngredient19': strIngredient19.toEJson(),
      'strIngredient20': strIngredient20.toEJson(),
      'strMeasure1': strMeasure1.toEJson(),
      'strMeasure2': strMeasure2.toEJson(),
      'strMeasure3': strMeasure3.toEJson(),
      'strMeasure4': strMeasure4.toEJson(),
      'strMeasure5': strMeasure5.toEJson(),
      'strMeasure6': strMeasure6.toEJson(),
      'strMeasure7': strMeasure7.toEJson(),
      'strMeasure8': strMeasure8.toEJson(),
      'strMeasure9': strMeasure9.toEJson(),
      'strMeasure10': strMeasure10.toEJson(),
      'strMeasure11': strMeasure11.toEJson(),
      'strMeasure12': strMeasure12.toEJson(),
      'strMeasure13': strMeasure13.toEJson(),
      'strMeasure14': strMeasure14.toEJson(),
      'strMeasure15': strMeasure15.toEJson(),
      'strMeasure16': strMeasure16.toEJson(),
      'strMeasure17': strMeasure17.toEJson(),
      'strMeasure18': strMeasure18.toEJson(),
      'strMeasure19': strMeasure19.toEJson(),
      'strMeasure20': strMeasure20.toEJson(),
      'strSource': strSource.toEJson(),
      'strImageSource': strImageSource.toEJson(),
      'strCreativeCommonsConfirmed': strCreativeCommonsConfirmed.toEJson(),
      'dateModified': dateModified.toEJson(),
    };
  }

  static EJsonValue _toEJson(Meal value) => value.toEJson();
  static Meal _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'idMeal': EJsonValue idMeal,
        'strMeal': EJsonValue strMeal,
        'strDrinkAlternate': EJsonValue strDrinkAlternate,
        'strCategory': EJsonValue strCategory,
        'strArea': EJsonValue strArea,
        'strInstructions': EJsonValue strInstructions,
        'strMealThumb': EJsonValue strMealThumb,
        'strTags': EJsonValue strTags,
        'strYoutube': EJsonValue strYoutube,
        'strIngredient1': EJsonValue strIngredient1,
        'strIngredient2': EJsonValue strIngredient2,
        'strIngredient3': EJsonValue strIngredient3,
        'strIngredient4': EJsonValue strIngredient4,
        'strIngredient5': EJsonValue strIngredient5,
        'strIngredient6': EJsonValue strIngredient6,
        'strIngredient7': EJsonValue strIngredient7,
        'strIngredient8': EJsonValue strIngredient8,
        'strIngredient9': EJsonValue strIngredient9,
        'strIngredient10': EJsonValue strIngredient10,
        'strIngredient11': EJsonValue strIngredient11,
        'strIngredient12': EJsonValue strIngredient12,
        'strIngredient13': EJsonValue strIngredient13,
        'strIngredient14': EJsonValue strIngredient14,
        'strIngredient15': EJsonValue strIngredient15,
        'strIngredient16': EJsonValue strIngredient16,
        'strIngredient17': EJsonValue strIngredient17,
        'strIngredient18': EJsonValue strIngredient18,
        'strIngredient19': EJsonValue strIngredient19,
        'strIngredient20': EJsonValue strIngredient20,
        'strMeasure1': EJsonValue strMeasure1,
        'strMeasure2': EJsonValue strMeasure2,
        'strMeasure3': EJsonValue strMeasure3,
        'strMeasure4': EJsonValue strMeasure4,
        'strMeasure5': EJsonValue strMeasure5,
        'strMeasure6': EJsonValue strMeasure6,
        'strMeasure7': EJsonValue strMeasure7,
        'strMeasure8': EJsonValue strMeasure8,
        'strMeasure9': EJsonValue strMeasure9,
        'strMeasure10': EJsonValue strMeasure10,
        'strMeasure11': EJsonValue strMeasure11,
        'strMeasure12': EJsonValue strMeasure12,
        'strMeasure13': EJsonValue strMeasure13,
        'strMeasure14': EJsonValue strMeasure14,
        'strMeasure15': EJsonValue strMeasure15,
        'strMeasure16': EJsonValue strMeasure16,
        'strMeasure17': EJsonValue strMeasure17,
        'strMeasure18': EJsonValue strMeasure18,
        'strMeasure19': EJsonValue strMeasure19,
        'strMeasure20': EJsonValue strMeasure20,
        'strSource': EJsonValue strSource,
        'strImageSource': EJsonValue strImageSource,
        'strCreativeCommonsConfirmed': EJsonValue strCreativeCommonsConfirmed,
        'dateModified': EJsonValue dateModified,
      } =>
        Meal(
          idMeal: fromEJson(idMeal),
          strMeal: fromEJson(strMeal),
          strCategory: fromEJson(strCategory),
          strArea: fromEJson(strArea),
          strInstructions: fromEJson(strInstructions),
          strMealThumb: fromEJson(strMealThumb),
          strYoutube: fromEJson(strYoutube),
          strDrinkAlternate: fromEJson(strDrinkAlternate),
          strTags: fromEJson(strTags),
          strIngredient1: fromEJson(strIngredient1),
          strIngredient2: fromEJson(strIngredient2),
          strIngredient3: fromEJson(strIngredient3),
          strIngredient4: fromEJson(strIngredient4),
          strIngredient5: fromEJson(strIngredient5),
          strIngredient6: fromEJson(strIngredient6),
          strIngredient7: fromEJson(strIngredient7),
          strIngredient8: fromEJson(strIngredient8),
          strIngredient9: fromEJson(strIngredient9),
          strIngredient10: fromEJson(strIngredient10),
          strIngredient11: fromEJson(strIngredient11),
          strIngredient12: fromEJson(strIngredient12),
          strIngredient13: fromEJson(strIngredient13),
          strIngredient14: fromEJson(strIngredient14),
          strIngredient15: fromEJson(strIngredient15),
          strIngredient16: fromEJson(strIngredient16),
          strIngredient17: fromEJson(strIngredient17),
          strIngredient18: fromEJson(strIngredient18),
          strIngredient19: fromEJson(strIngredient19),
          strIngredient20: fromEJson(strIngredient20),
          strMeasure1: fromEJson(strMeasure1),
          strMeasure2: fromEJson(strMeasure2),
          strMeasure3: fromEJson(strMeasure3),
          strMeasure4: fromEJson(strMeasure4),
          strMeasure5: fromEJson(strMeasure5),
          strMeasure6: fromEJson(strMeasure6),
          strMeasure7: fromEJson(strMeasure7),
          strMeasure8: fromEJson(strMeasure8),
          strMeasure9: fromEJson(strMeasure9),
          strMeasure10: fromEJson(strMeasure10),
          strMeasure11: fromEJson(strMeasure11),
          strMeasure12: fromEJson(strMeasure12),
          strMeasure13: fromEJson(strMeasure13),
          strMeasure14: fromEJson(strMeasure14),
          strMeasure15: fromEJson(strMeasure15),
          strMeasure16: fromEJson(strMeasure16),
          strMeasure17: fromEJson(strMeasure17),
          strMeasure18: fromEJson(strMeasure18),
          strMeasure19: fromEJson(strMeasure19),
          strMeasure20: fromEJson(strMeasure20),
          strSource: fromEJson(strSource),
          strImageSource: fromEJson(strImageSource),
          strCreativeCommonsConfirmed: fromEJson(strCreativeCommonsConfirmed),
          dateModified: fromEJson(dateModified),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Meal._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Meal, 'Meal', [
      SchemaProperty('idMeal', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('strMeal', RealmPropertyType.string),
      SchemaProperty('strDrinkAlternate', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strCategory', RealmPropertyType.string),
      SchemaProperty('strArea', RealmPropertyType.string),
      SchemaProperty('strInstructions', RealmPropertyType.string),
      SchemaProperty('strMealThumb', RealmPropertyType.string),
      SchemaProperty('strTags', RealmPropertyType.string, optional: true),
      SchemaProperty('strYoutube', RealmPropertyType.string),
      SchemaProperty('strIngredient1', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient2', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient3', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient4', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient5', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient6', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient7', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient8', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient9', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient10', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient11', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient12', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient13', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient14', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient15', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient16', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient17', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient18', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient19', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strIngredient20', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strMeasure1', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure2', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure3', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure4', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure5', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure6', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure7', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure8', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure9', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure10', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure11', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure12', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure13', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure14', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure15', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure16', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure17', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure18', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure19', RealmPropertyType.string, optional: true),
      SchemaProperty('strMeasure20', RealmPropertyType.string, optional: true),
      SchemaProperty('strSource', RealmPropertyType.string, optional: true),
      SchemaProperty('strImageSource', RealmPropertyType.string,
          optional: true),
      SchemaProperty('strCreativeCommonsConfirmed', RealmPropertyType.string,
          optional: true),
      SchemaProperty('dateModified', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
