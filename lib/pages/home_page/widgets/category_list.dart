import 'package:flutter/material.dart';

class CategoryReceipeList extends StatelessWidget {
  const CategoryReceipeList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints;
        final categoryItemHeight = size.maxHeight * 0.7;
        final categoryTitleHeight = size.maxHeight * 0.3;
        final categoryItemWidth = size.maxWidth * 0.4;
        final categoryTitlePadding = size.maxWidth * 0.01;
        const categoryTitleText = 'Category';
        const categoryTitleColor = Colors.black;
        final categoryTitleFontSize = categoryTitleHeight * 0.5;
        return Column(
          children: [
            SizedBox(
                height: categoryTitleHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(categoryTitlePadding),
                    child: Text(
                      categoryTitleText,
                      style: TextStyle(
                          color: categoryTitleColor,
                          fontSize: categoryTitleFontSize),
                    ),
                  ),
                )),
            SizedBox(
              height: categoryItemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: categoryItemWidth,
                    child: const CategoryListItem(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = size.width * 0.01;
    final itemBorderRadius = size.width * 0.07;
    const itemTextColor = Colors.black;
    const imageOpacity = 0.5;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage('assets/images/hashbrown.jpg'),
                fit: BoxFit.cover,
                opacity: imageOpacity),
            borderRadius: BorderRadius.circular(itemBorderRadius)),
        child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'BreakFast',
              style:
                  TextStyle(color: itemTextColor, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
