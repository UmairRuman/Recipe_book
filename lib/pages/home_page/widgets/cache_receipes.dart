import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class RandomReceipeItem extends StatelessWidget {
  const RandomReceipeItem({super.key, required this.meal});
  final Meal meal;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final itemPadding = size.height * 0.01;
    final itemBorderRadius = size.width * 0.05;
    const itemImageOpacity = 0.6;
    final itemTitleFontSize = size.height * 0.04;
    final itemBorderWidth = size.width * 0.004;
    return GestureDetector(
      onTap: () => Get.toNamed(RecipePage.pageAddress, arguments: meal),
      child: Padding(
        padding: EdgeInsets.all(itemPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(itemBorderRadius),
            border: Border.all(width: itemBorderWidth, color: Colors.black),
            image: DecorationImage(
                image: NetworkImage(meal.strMealThumb),
                fit: BoxFit.cover,
                opacity: itemImageOpacity),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  meal.strMeal,
                  style: TextStyle(
                    fontSize: itemTitleFontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CacheReceipesTitle extends StatelessWidget {
  const CacheReceipesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final titlePadding = size.height * 0.01;
    final titleFontSize = size.height * 0.03;
    const titleTextColor = Colors.black;
    const titleText = 'Meal of the Day';
    return Padding(
      padding: EdgeInsets.all(titlePadding),
      child: Text(
        titleText,
        style: TextStyle(color: titleTextColor, fontSize: titleFontSize),
      ),
    );
  }
}
