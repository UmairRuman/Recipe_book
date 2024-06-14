import 'package:flutter/material.dart';

class IngredientAndQuantityHeadings extends StatelessWidget {
  const IngredientAndQuantityHeadings({super.key});
  static const ingredients = 'Ingredients';
  static const quantity = 'Quantity';
  static const ingredientsAndQuantityPaddingFromLeft = 0.05;
  static const ingredientsAndQuantityPaddingFromTop = 0.02;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final style = TextStyle(
      color: Colors.black,
      fontSize: height * 0.03,
    );
    return Padding(
      padding: EdgeInsets.only(
          left: width * ingredientsAndQuantityPaddingFromLeft,
          top: height * ingredientsAndQuantityPaddingFromTop),
      child: Row(
        children: [
          Expanded(
              flex: 10,
              child: Text(
                ingredients,
                style: style,
              )),
          const Spacer(
            flex: 7,
          ),
          Expanded(
              flex: 10,
              child: Text(
                quantity,
                style: style,
              )),
        ],
      ),
    );
  }
}
