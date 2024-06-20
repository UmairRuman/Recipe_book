import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/database_services/meal.dart';

class FavouriteReciepeList extends StatelessWidget {
  const FavouriteReciepeList({super.key, required this.favMeals});
  final List<Meal> favMeals;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints;
        final favouriteItemWidth = size.maxWidth * 0.55;
        final favouriteItemHeight = size.maxHeight * 0.7;
        final favouriteTitleTextHeight = size.maxHeight * 0.3;
        final favouriteTitleTextFontSize = favouriteTitleTextHeight * 0.5;
        const favouriteTitleTextColor = Colors.black;
        const favouriteTitleText = 'Favourites';
        final favouriteTitleTextPadding = size.maxHeight * 0.01;
        return Column(
          children: [
            SizedBox(
              height: favouriteTitleTextHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(favouriteTitleTextPadding),
                  child: Text(
                    favouriteTitleText,
                    style: TextStyle(
                        color: favouriteTitleTextColor,
                        fontSize: favouriteTitleTextFontSize),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: favouriteItemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: favMeals.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: favouriteItemWidth,
                      child: FavListItem(
                        favouriteItem: favMeals[index],
                      ));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class FavListItem extends StatelessWidget {
  const FavListItem({super.key, required this.favouriteItem});
  final Meal favouriteItem;
  @override
  Widget build(BuildContext context) {
    log(favouriteItem.strMealThumb.toString());
    final size = MediaQuery.sizeOf(context);
    final padding = size.width * 0.01;
    final itemBorderRadius = size.width * 0.07;
    const imageOpacity = 0.4;
    const textColor = Colors.white;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(RecipePage.pageAddress,
              arguments: favouriteItem.copiedObject);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(favouriteItem.strMealThumb),
                  fit: BoxFit.cover,
                  opacity: imageOpacity),
              borderRadius: BorderRadius.circular(itemBorderRadius)),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                favouriteItem.strMeal,
                style: const TextStyle(
                    color: textColor, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
