import 'package:flutter/material.dart';

class CacheReceipesList extends StatelessWidget {
  const CacheReceipesList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final itemPadding = size.height * 0.01;
    final itemBorderRadius = size.width * 0.05;
    const itemImageOpacity = 0.6;
    final itemTitleFontSize = size.height * 0.04;
    return Padding(
      padding: EdgeInsets.all(itemPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(itemBorderRadius),
          image: const DecorationImage(
              image: AssetImage('assets/images/hashbrown.jpg'),
              fit: BoxFit.cover,
              opacity: itemImageOpacity),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Dish Name',
            style: TextStyle(
              fontSize: itemTitleFontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class CacheReceipesTitle extends StatelessWidget {
  const CacheReceipesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final titlePadding = size.height * 0.01;
    final titleFontSize = size.height * 0.04;
    const titleTextColor = Colors.black;
    const titleText = 'Top Trending';
    return Padding(
      padding: EdgeInsets.all(titlePadding),
      child: Text(
        titleText,
        style: TextStyle(color: titleTextColor, fontSize: titleFontSize),
      ),
    );
  }
}
