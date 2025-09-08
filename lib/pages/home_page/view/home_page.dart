import 'dart:developer';

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
    final categoryItemHeight = height * 0.28;
    final favouriteReciepeItemHeight = height * 0.28;
    final cacheReceipeItemHeight = height * 0.45;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        // appBar: PreferredSize(
        //   preferredSize: Size(width, 56),
        //   child: const EnhancedSearchBarWidget(),
        // ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Welcome Header with Animation
              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good ${_getGreeting()}!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey[600],
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'What would you like to cook?',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Search Bar
              const SliverToBoxAdapter(child: EnhancedSearchBarWidget()),

              // Categories Section
              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 40 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: SizedBox(
                          height: categoryItemHeight,
                          child: Obx(() {
                            controller.loadData();
                            if (controller.datafetched.isFalse) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF6B73FF),
                                  strokeWidth: 3,
                                ),
                              );
                            } else {
                              return CategoryReceipeList(
                                categories: controller.categories,
                              );
                            }
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Favourites Section
              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 40 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Obx(() {
                          if (controller.favouritesFetched.isFalse) {
                            return SizedBox(
                              height: favouriteReciepeItemHeight,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF6B73FF),
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          } else {
                            log('favourite list built');
                            return SizedBox(
                              height: favouriteReciepeItemHeight,
                              child: FavouriteReciepeList(
                                favMeals: controller.favouriteMealsList,
                              ),
                            );
                          }
                        }),
                      ),
                    );
                  },
                ),
              ),

              // Meal of the Day Section
              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1400),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 40 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: const CacheReceipesTitle(),
                      ),
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: SizedBox(
                          height: cacheReceipeItemHeight,
                          width: cacheReceipeItemHeight,
                          child: Obx(() {
                            if (controller.randomMealReceived.isFalse) {
                              controller.getRandomDish();
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF6B73FF),
                                  strokeWidth: 3,
                                ),
                              );
                            } else {
                              return RandomReceipeItem(
                                meal: controller.randomMeal!,
                              );
                            }
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
