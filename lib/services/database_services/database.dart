import 'dart:developer';

import 'package:realm/realm.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class DBHelper {
  static DBHelper? _instance;
  static Realm? _db;
  static const schemaVersion = 3;
  DBHelper._();

  factory DBHelper() => _instance ??= DBHelper._();

  Realm get _databse => _db ??=
      Realm(Configuration.local([Meal.schema], schemaVersion: schemaVersion));

  void insert(Meal meal) {
    _databse.write(
      () {
        _databse.add<Meal>(meal);
      },
    );
  }

  void delete(String mealId) {
    log(mealId);
    var foundObject = _databse.find<Meal>(mealId);
    if (foundObject != null) {
      _databse.write(
        () {
          _databse.delete<Meal>(foundObject);
        },
      );
    }
  }

  List<Meal> favouriteMeals() {
    return _databse.all<Meal>().toList();
  }

  bool isFavourite(String mealId) {
    final meals = _databse.all<Meal>().toList();
    //If meals is empty means there is no favourite
    if (meals.isEmpty) {
      return false;
    } else {
      //check if meal is present and return the result
      bool isPresent = false;
      for (var element in meals) {
        if (element.idMeal == mealId) {
          isPresent = true;
          break;
        }
      }
      return isPresent;
    }
  }

  void deleteAllMeals() {
    _databse.write(
      () {
        _databse.deleteAll<Meal>();
      },
    );
  }
}
