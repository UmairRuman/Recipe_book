import 'package:realm/realm.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class DBHelper {
  static DBHelper? _instance;
  static Realm? _db;
  static const schemaVersion = 2;
  DBHelper._();

  factory DBHelper() => _instance ??= DBHelper._();

  Realm get _databse => _db ??=
      Realm(Configuration.local([Meal.schema], schemaVersion: schemaVersion));

  void insert(Meal meal) {
    _databse.write(
      () {
        _databse.add(meal);
      },
    );
  }

  void update(Meal meal) {
    _databse.write(
      () {
        _databse.add(meal, update: true);
      },
    );
  }

  void delete(Meal meal) {
    _databse.write(
      () {
        _databse.delete(meal);
      },
    );
  }

  List<Meal> favouriteMeals() {
    return _databse.all<Meal>().toList();
  }

  bool isFavourite(Meal meal) {
    final meals = _databse.all<Meal>().toList();
    //If meals is empty means there is no favourite
    if (meals.isEmpty) {
      return false;
    } else {
      //check if meal is present and return the result
      return meals.contains(meal);
    }
  }
}
