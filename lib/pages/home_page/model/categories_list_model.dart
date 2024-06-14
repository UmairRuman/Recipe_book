import 'dart:convert';

class CategoriesModel {
  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;
  CategoriesModel({
    this.idCategory = '',
    this.strCategory = '',
    this.strCategoryThumb = '',
    this.strCategoryDescription = '',
  });

  CategoriesModel copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
  }) {
    return CategoriesModel(
      idCategory: idCategory ?? this.idCategory,
      strCategory: strCategory ?? this.strCategory,
      strCategoryThumb: strCategoryThumb ?? this.strCategoryThumb,
      strCategoryDescription:
          strCategoryDescription ?? this.strCategoryDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCategory': idCategory,
      'strCategory': strCategory,
      'strCategoryThumb': strCategoryThumb,
      'strCategoryDescription': strCategoryDescription,
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> map) {
    return CategoriesModel(
      idCategory: map['idCategory'] as String,
      strCategory: map['strCategory'] as String,
      strCategoryThumb: map['strCategoryThumb'] as String,
      strCategoryDescription: map['strCategoryDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesModel.fromJson(String source) =>
      CategoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(idCategory: $idCategory, strCategory: $strCategory, strCategoryThumb: $strCategoryThumb, strCategoryDescription: $strCategoryDescription)';
  }

  @override
  bool operator ==(covariant CategoriesModel other) {
    if (identical(this, other)) return true;

    return other.idCategory == idCategory &&
        other.strCategory == strCategory &&
        other.strCategoryThumb == strCategoryThumb &&
        other.strCategoryDescription == strCategoryDescription;
  }

  @override
  int get hashCode {
    return idCategory.hashCode ^
        strCategory.hashCode ^
        strCategoryThumb.hashCode ^
        strCategoryDescription.hashCode;
  }
}
