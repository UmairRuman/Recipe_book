import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/cache_receipes.dart';
import 'package:recipe_book/pages/home_page/widgets/category_list.dart';
import 'package:recipe_book/pages/home_page/widgets/fav_list.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  static const pageAddress = '/';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final searchBarHeight = height * 0.1;
    final categoryItemHeight = height * 0.25;
    final favouriteReciepeItemHeight = height * 0.25;
    final cacheReceipeItemHeight = height * 0.40;
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(
                height: searchBarHeight, child: const HomeSearchBarWidget());
          } else if (index == 1) {
            return SizedBox(
              height: categoryItemHeight,
              child: Obx(
                () {
                  controller.loadData();
                  if (controller.datafetched.isFalse) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return CategoryReceipeList(
                        categories: controller.categories);
                  }
                },
              ),
            );
          } else if (index == 2) {
            return SizedBox(
                height: favouriteReciepeItemHeight,
                child: const FavouriteReciepeList());
          } else if (index == 3) {
            return const CacheReceipesTitle();
          } else {
            return SizedBox(
              height: cacheReceipeItemHeight,
              width: cacheReceipeItemHeight,
              child: Obx(
                () {
                  if (controller.randomMealReceived.isFalse) {
                    controller.getRandomDish();
                    return const CircularProgressIndicator();
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
