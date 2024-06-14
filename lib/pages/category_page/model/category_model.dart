import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CategoryModel {
  String? idCategory;
  String? strCategory;
  String? strCategoryThumb;
  String? strCategoryDescription;
  CategoryModel({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  CategoryModel copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
  }) {
    return CategoryModel(
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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      idCategory:
          map['idCategory'] != null ? map['idCategory'] as String : null,
      strCategory:
          map['strCategory'] != null ? map['strCategory'] as String : null,
      strCategoryThumb: map['strCategoryThumb'] != null
          ? map['strCategoryThumb'] as String
          : null,
      strCategoryDescription: map['strCategoryDescription'] != null
          ? map['strCategoryDescription'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(idCategory: $idCategory, strCategory: $strCategory, strCategoryThumb: $strCategoryThumb, strCategoryDescription: $strCategoryDescription)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
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
