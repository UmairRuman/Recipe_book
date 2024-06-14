import 'package:flutter/material.dart';

class IngredientsQuantityTile extends StatelessWidget {
  const IngredientsQuantityTile(
      {super.key, required this.ingredient, required this.quantity});
  final String ingredient, quantity;
  @override
  Widget build(BuildContext context) {
    final Size(:height) = MediaQuery.sizeOf(context);
    final style = TextStyle(color: Colors.black, fontSize: height * 0.02);
    return Material(
      child: ListTile(
        leading: Text(
          ingredient,
          style: style,
        ),
        trailing: Text(
          quantity,
          style: style,
        ),
      ),
    );
  }
}
