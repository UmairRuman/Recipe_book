import 'package:flutter/material.dart';

class RecipeAndTutorialDesign extends StatelessWidget {
  const RecipeAndTutorialDesign({super.key});
  static const recipe = 'Recipe :';
  static const tutorial = 'Tutorial :';
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.035,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02, left: width * 0.03),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    recipe,
                    style: style,
                  ))),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            tutorial,
                            style: style,
                          ))),
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                            onPressed: () {
                              //take to youtube
                            },
                            icon: const Icon(Icons.play_circle_outlined)),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
