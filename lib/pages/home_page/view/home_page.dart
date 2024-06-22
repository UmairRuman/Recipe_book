import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/cache_receipes.dart';
import 'package:recipe_book/pages/home_page/widgets/category_list.dart';
import 'package:recipe_book/pages/home_page/widgets/fav_list.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Widget/search_bar_widget.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  static const pageAddress = '/';
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final categoryItemHeight = height * 0.25;
    final favouriteReciepeItemHeight = height * 0.25;
    final cacheReceipeItemHeight = height * 0.40;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width, 56), child: const HomeSearchBarWidget()),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(
              height: categoryItemHeight,
              child: Obx(
                () {
                  controller.loadData();
                  if (controller.datafetched.isFalse) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else {
                    return CategoryReceipeList(
                        categories: controller.categories);
                  }
                },
              ),
            );
          } else if (index == 1) {
            return Obx(
              () {
                if (controller.favouritesFetched.isFalse) {
                  return SizedBox(
                    height: favouriteReciepeItemHeight,
                    child: const CupertinoActivityIndicator(),
                  );
                } else {
                  log('favourite list built');
                  return SizedBox(
                    height: favouriteReciepeItemHeight,
                    child: FavouriteReciepeList(
                        favMeals: controller.favouriteMealsList),
                  );
                }
              },
            );
          } else if (index == 2) {
            return const CacheReceipesTitle();
          } else {
            return SizedBox(
              height: cacheReceipeItemHeight,
              width: cacheReceipeItemHeight,
              child: Obx(
                () {
                  if (controller.randomMealReceived.isFalse) {
                    controller.getRandomDish();
                    return const Center(child: CupertinoActivityIndicator());
                  } else {
                    return RandomReceipeItem(meal: controller.randomMeal!);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
