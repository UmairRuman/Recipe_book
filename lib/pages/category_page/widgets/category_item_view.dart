import 'package:flutter/material.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/pages/category_page/widgets/item_view_bottom_design.dart';

class CategoryItemView extends StatelessWidget {
  const CategoryItemView({super.key, required this.category});
  final CategoriesModel category;
  static const shadows = [
    BoxShadow(
        color: Colors.black54,
        blurRadius: 20,
        spreadRadius: 5,
        offset: Offset(3, 3))
  ];

  static const recipeNamePaddingFromTop = 0.3;
  static const recipeNamePaddingFromLeft = 0.05;
  static const imageWidth = 0.85;
  static const imageHeight = 0.8;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final recipeStyle = TextStyle(
        color: Colors.black,
        fontSize: height * 0.025,
        fontWeight: FontWeight.bold);
    return Center(
      child: Container(
        width: width * 0.8,
        height: height * 0.4,
        decoration: BoxDecoration(
          boxShadow: shadows,
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            width * 0.05,
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox.expand(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * imageWidth,
                          height: constraints.maxHeight * imageHeight,
                          child: Image.network(
                            category.strCategoryThumb,
                          ),
                        ),
                        Positioned(
                            top: constraints.maxHeight * 0.1,
                            right: constraints.maxWidth * 0.08,
                            child: const Icon(Icons.favorite_outline))
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: SizedBox.expand(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Padding(
                      padding: EdgeInsets.only(
                          top: constraints.maxHeight * recipeNamePaddingFromTop,
                          left:
                              constraints.maxWidth * recipeNamePaddingFromLeft),
                      child: Text(
                        category.strCategory,
                        style: recipeStyle,
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: CategoryIetmViewBottomDesign(
                  recipeDetail: category.strCategoryDescription,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
