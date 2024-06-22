import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';
import 'package:recipe_book/pages/category_page/widgets/category_list.dart';
import 'package:recipe_book/pages/category_page/widgets/category_search_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  static const pageAddress = '/category';

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void rebuildPage() {
    setState(() {
      log('category page rebuilt');
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final Size(:width) = MediaQuery.sizeOf(context);
    final List<CategoryItem> categories = Get.arguments;
    controller.iconsList.addAll(List.generate(
      categories.length,
      (index) => const Icon(Icons.favorite_border_outlined),
    ));
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width, 56),
          child: CategorySearchBarWidget(
            rebuildFunction: rebuildPage,
            categoriesList: categories,
          )),
      body: Center(
        child: CategoryList(categories: categories),
      ),
    );
  }
}
