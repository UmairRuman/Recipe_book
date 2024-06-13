import 'package:flutter/material.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredients_and_quantity_tile.dart';

class IngredientsQuantityList extends StatelessWidget {
  const IngredientsQuantityList({super.key});

  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return SizedBox(
      width: width * 0.93,
      height: height * 0.4,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const IngredientsQuantityTile(),
      ),
    );
  }
}
