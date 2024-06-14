import 'package:flutter/material.dart';

class IngredientsQuantityTile extends StatelessWidget {
  const IngredientsQuantityTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Size(:height) = MediaQuery.sizeOf(context);
    final style = TextStyle(color: Colors.black, fontSize: height * 0.02);
    return Material(
      child: ListTile(
        leading: Text(
          'Lemon',
          style: style,
        ),
        trailing: Text(
          '1 tbs',
          style: style,
        ),
      ),
    );
  }
}
