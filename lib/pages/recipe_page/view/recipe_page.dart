import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/pages/recipe_page/model/meals_api_model.dart';
import 'package:recipe_book/pages/recipe_page/widgets/app_bar_design.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredeints_quantity_list.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredient_and_quantity_design.dart';
import 'package:recipe_book/pages/recipe_page/widgets/recipe_tutorial_design.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  static const pageAddress = '/recipe';
  static const instructions = 'Instructions :';
  static const originalRecipeLink = 'Recipe link :';
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecipeController());
    final MealsModel meal = Get.arguments;
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.03,
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.25,
        flexibleSpace: const RecipeAppBarDesign(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeAndTutorialDesign(
              recipeName: meal.strMeal,
              videoUrl: meal.strYoutube,
            ),
            const IngredientAndQuantityHeadings(),
            IngredientsQuantityList(
              ingredientsAndQuantityList:
                  controller.ingredientsAndQuantityList(meal.toMap()),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07),
              child: Text(
                instructions,
                style: style,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07),
              child: SizedBox(
                width: width * 0.8,
                child: Text(
                  meal.strInstructions,
                ),
              ),
            ),
            if (meal.strSource.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.07,
                    top: height * 0.02,
                    bottom: height * 0.02),
                child: SizedBox(
                  width: width * 0.85,
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                      text: '\u{1F517}',
                    ),
                    TextSpan(
                        text: meal.strSource,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ))
                  ])),
                ),
              )
          ],
        ),
      ),
    );
  }
}
