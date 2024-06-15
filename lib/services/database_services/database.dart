import 'dart:developer';

import 'package:realm/realm.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class DBHelper {
  static DBHelper? _instance;
  static Realm? _db;
  static const schemaVersion = 2;
  DBHelper._();

  factory DBHelper() => _instance ??= DBHelper._();

  Realm get _database => _db ??=
      Realm(Configuration.local([Meal.schema], schemaVersion: schemaVersion));

  void insert(Meal meal) {
    log('meal id : ${meal.idMeal}');
    _database.write(
      () {
        _database.add<Meal>(meal);
      },
    );
    log(_database.all<Meal>().toList().toString());
  }

  void delete(Meal meal) {
    _database.write(
      () {
        _database.delete<Meal>(meal);
      },
    );
    log('deleted');
  }

  List<Meal> favouriteMeals() {
    return _database.all<Meal>().toList();
  }

  bool isFavourite(Meal meal) {
    final meals = _database.all<Meal>().toList();
    //If meals is empty means there is no favourite
    if (meals.isEmpty) {
      log('[list is empty]');
      return false;
    } else {
      log('list not empty meal present : ${meals.contains(meal).toString()}');
      //check if meal is present and return the result
      return meals.contains(meal);
    }
  }

  void deleteAll() {
    log('before deleting total favourites : ${_database.all<Meal>().toList().length}');
    log(_database.all<Meal>().toList()[0].toString());
    _database.write(() => _database.deleteAll<Meal>());
    log('after dleeting total favourites : ${_database.all<Meal>().toList().toString()}');
  }
}
