import 'package:flutter/material.dart';
import 'package:recipe_book/pages/recipe_page/widgets/ingredients_and_quantity_tile.dart';

class IngredientsQuantityList extends StatelessWidget {
  const IngredientsQuantityList(
      {super.key, required this.ingredientsAndQuantityList});
  final (List<String>, List<String>) ingredientsAndQuantityList;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return SizedBox(
      width: width * 0.93,
      height: height * 0.4,
      child: ListView.builder(
        itemCount: ingredientsAndQuantityList.$1.length,
        itemBuilder: (context, index) => IngredientsQuantityTile(
          ingredient: ingredientsAndQuantityList.$1[index],
          quantity: ingredientsAndQuantityList.$2[index],
        ),
      ),
    );
  }
}
