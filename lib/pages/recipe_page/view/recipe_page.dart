import 'package:flutter/material.dart';
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
            const RecipeAndTutorialDesign(
              recipeName: 'Spicy Arrabiata Penne',
            ),
            const IngredientAndQuantityHeadings(),
            const IngredientsQuantityList(),
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
                child: const Text(
                    'In this recipe we will be going to make fish tacos and now we will tak a fish and a tco and now we have a taco fish.Now go and make your fish tacoa and ow i am going to finish this ui and then go to slppe and gaian work on this in the morining'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.07,
                  top: height * 0.02,
                  bottom: height * 0.02),
              child: SizedBox(
                width: width * 0.85,
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: '\u{1F517}',
                  ),
                  TextSpan(
                      text:
                          'https://www.bbcgoodfood.com/recipes/3028701/threecheese-souffls',
                      style: TextStyle(
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
