import 'dart:convert';

class CategoryItem {
  String strMeal = '';
  String strMealThumb = '';
  String idMeal = '';
  CategoryItem({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });

  CategoryItem copyWith({
    String? strMeal,
    String? strMealThumb,
    String? idMeal,
  }) {
    return CategoryItem(
      strMeal: strMeal ?? this.strMeal,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      idMeal: idMeal ?? this.idMeal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'idMeal': idMeal,
    };
  }

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      strMeal: map['strMeal'] as String,
      strMealThumb: map['strMealThumb'] as String,
      idMeal: map['idMeal'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryItem.fromJson(String source) =>
      CategoryItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CategoryModel(strMeal: $strMeal, strMealThumb: $strMealThumb, idMeal: $idMeal)';

  @override
  bool operator ==(covariant CategoryItem other) {
    if (identical(this, other)) return true;

    return other.strMeal == strMeal &&
        other.strMealThumb == strMealThumb &&
        other.idMeal == idMeal;
  }

  @override
  int get hashCode =>
      strMeal.hashCode ^ strMealThumb.hashCode ^ idMeal.hashCode;
}
