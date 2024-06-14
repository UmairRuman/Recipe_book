import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';

class CategoryItemViewBottomDesign extends GetView<CategoryController> {
  const CategoryItemViewBottomDesign({
    super.key,
    required this.recipeDetail,
    required this.recipeName,
  });
  final String recipeDetail, recipeName;
  static const btnText = 'See full recipe';
  static const maxTextLines = 4;
  static const recipePaddingFromLeft = 0.08;
  static const btnPaddingFromRight = 0.05;
  static const btnPaddingFromBottom = 0.1;

  void _onBtnTap() {
    controller.navigateToRecipePage(mealName: recipeName);
  }

  @override
  Widget build(BuildContext context) {
    final recipeDetailStyle = TextStyle(
      color: Colors.grey.shade400,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                    padding: EdgeInsets.only(
                      left: constraints.maxWidth * recipePaddingFromLeft,
                    ),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxTextLines,
                      recipeDetail,
                      style: recipeDetailStyle,
                    ),
                  )),
        ),
        Expanded(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * btnPaddingFromBottom,
                      right: constraints.maxWidth * btnPaddingFromRight),
                  child: FittedBox(
                    child: TextButton(
                      onPressed: _onBtnTap,
                      child: const Text(btnText),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
