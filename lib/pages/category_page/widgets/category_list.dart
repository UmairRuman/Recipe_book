import 'package:flutter/material.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/widgets/category_item_view.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  Widget build(BuildContext context) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: categories.length,
      (context, index) => Padding(
        padding: EdgeInsets.only(top: height * 0.02),
        child: CategoryItemView(
          category: categories[index],
        ),
      ),
    ));
  }
}
