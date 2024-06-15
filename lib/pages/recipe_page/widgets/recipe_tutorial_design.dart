import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';

class RecipeAndTutorialDesign extends GetView<RecipeController> {
  const RecipeAndTutorialDesign(
      {super.key, required this.recipeName, required this.videoUrl});
  final String recipeName, videoUrl;
  static const recipe = 'Recipe :  ';
  static const tutorial = 'Watch Video';
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.03,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02, left: width * 0.03),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  recipeName,
                  style: style,
                ),
              )),
          Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  controller.openYoutubeVideo(context, videoUrl);
                },
                child: const Text(
                  tutorial,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
