import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';

class CategoryReceipeList extends StatelessWidget {
  final List<CategoriesModel> categories;
  const CategoryReceipeList({super.key, required this.categories});

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
              ),
            ),
            SizedBox(
              height: categoryItemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var currentCategory = categories[index];
                  return SizedBox(
                    width: categoryItemWidth,
                    child: CategoryListItem(
                      category: currentCategory,
                    ),
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

class CategoryListItem extends GetView<HomePageController> {
  final CategoriesModel category;
  const CategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = size.width * 0.01;
    final borderWidth = size.width * 0.003;
    final itemBorderRadius = size.width * 0.07;
    const itemTextColor = Colors.black;
    const imageOpacity = 0.7;
    return GestureDetector(
      onTap: () {
        controller.pushCategoryPage(category.strCategory);
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: Colors.black),
              image: DecorationImage(
                  image: NetworkImage(category.strCategoryThumb),
                  fit: BoxFit.fill,
                  opacity: imageOpacity),
              borderRadius: BorderRadius.circular(itemBorderRadius)),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                category.strCategory,
                style: const TextStyle(
                    color: itemTextColor, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
