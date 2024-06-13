import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
          name: '/category',
          page: () => const CategoryPage(),
        ),
        GetPage(
          name: '/recipe',
          page: () => const RecipePage(),
        )
      ],
      debugShowCheckedModeBanner: false,
      home: const CategoryPage(),
    );
  }
}
