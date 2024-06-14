import 'package:realm/realm.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class DBHelper {
  static DBHelper? _instance;
  static Realm? _db;
  static const schemaVersion = 1;
  DBHelper._();

  factory DBHelper() => _instance ??= DBHelper._();

  Realm get _databse => _db ??=
      Realm(Configuration.local([Meal.schema], schemaVersion: schemaVersion));

  void insert(Meal model) {
    _databse.write(
      () {
        _databse.add(model);
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

  List<Meal> fetchMeals() {
    return _databse.all<Meal>().toList();
  }
}
