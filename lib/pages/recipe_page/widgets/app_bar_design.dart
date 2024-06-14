import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';

class RecipeAppBarDesign extends StatelessWidget {
  const RecipeAppBarDesign({super.key, required this.mealImage});
  final String mealImage;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final recipeController = Get.find<RecipeController>();
        final borderRadius = Radius.circular(constraints.maxWidth * 0.15);
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: borderRadius,
              bottomRight: borderRadius,
            ),
            image: DecorationImage(
                image: NetworkImage(
                  mealImage,
                ),
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
                opacity: 0.8),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.1),
                child: IconButton(
                    onPressed: recipeController.navigateBackToCategoryPage,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.1),
                child: ButtonBar(
                  children: [
                    IconButton(
                        onPressed: () {
                          recipeController.scheduleNotification(
                              context, 'Timer up');
                        },
                        icon: const Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          //add to favourites list
                        },
                        icon: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
