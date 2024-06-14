import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';

class CategoryItemView extends GetView<CategoryController> {
  const CategoryItemView({super.key, required this.category});
  final CategoryItem category;
  static const shadows = [
    BoxShadow(
        color: Colors.black54,
        blurRadius: 20,
        spreadRadius: 5,
        offset: Offset(3, 3))
  ];
  static const recipeNamePaddingFromTop = 0.3;
  static const recipeNamePaddingFromLeft = 0.05;
  static const favIconSpacingFromTop = 0.1;
  static const favIconSpacingFromRight = 0.08;
  static const avatarRadius = 0.08;
  static const btnText = 'See Recipe';

  void _onBtnTap() {
    controller.navigateToRecipePage(mealName: category.strMeal);
  }

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
                        CircleAvatar(
                          radius: height * avatarRadius,
                          backgroundImage: NetworkImage(
                            category.strMealThumb,
                          ),
                        ),
                        Positioned(
                            top: constraints.maxHeight * favIconSpacingFromTop,
                            right:
                                constraints.maxWidth * favIconSpacingFromRight,
                            child: const Icon(Icons.favorite_outline))
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: SizedBox.expand(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Padding(
                      padding: EdgeInsets.only(
                          top: constraints.maxHeight * recipeNamePaddingFromTop,
                          left:
                              constraints.maxWidth * recipeNamePaddingFromLeft),
                      child: Text(
                        category.strMeal,
                        style: recipeStyle,
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: _onBtnTap,
                    child: const Text(btnText),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
