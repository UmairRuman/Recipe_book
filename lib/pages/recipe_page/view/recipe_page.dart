import 'package:flutter/material.dart';
import 'package:recipe_book/pages/recipe_page/widgets/app_bar_design.dart';
import 'package:recipe_book/pages/recipe_page/widgets/recipe_tutorial_design.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  static const pageName = '/recipe';

  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.035,
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
            const RecipeAndTutorialDesign(),
            Padding(
              padding: EdgeInsets.only(left: width * 0.07),
              child: Text(
                'Fish Tacos',
                style: style,
              ),
            )
          ],
        ),
      ),
    );
  }
}
