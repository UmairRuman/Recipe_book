import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/profile_controller.dart';
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/widgets/cache_receipes.dart';
import 'package:recipe_book/pages/home_page/widgets/category_list.dart';
import 'package:recipe_book/pages/home_page/widgets/fav_list.dart';
import 'package:recipe_book/pages/home_page/widgets/search_bar/Widget/search_bar_widget.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});
  static const pageAddress = '/home';

  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final categoryItemHeight = height * 0.28;
    final favouriteReciepeItemHeight = height * 0.28;
    final cacheReceipeItemHeight = height * 0.45;

    // Get ProfileController
    final profileController = Get.find<ProfileController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar with Profile
              _buildAnimatedAppBar(profileController),

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
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                final profile = profileController.userProfile.value;
                                final name = profile?.displayName ?? 'Chef';
                                return Text(
                                  'Good ${_getGreeting()}, $name!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[600],
                                    letterSpacing: 0.5,
                                  ),
                                );
                              }),
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

              // Profile Completion Banner (if incomplete)
              Obx(() {
                final completion = profileController.profileCompletion.value;
                if (completion >= 80) return const SliverToBoxAdapter(child: SizedBox.shrink());
                
                return SliverToBoxAdapter(
                  child: _buildProfileCompletionBanner(profileController, completion),
                );
              }),

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

  Widget _buildAnimatedAppBar(ProfileController profileController) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const FlexibleSpaceBar(
          centerTitle: false,
          title: Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Recipe Book',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Notifications
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // TODO: Navigate to notifications
          },
        ),

        // Profile Avatar
        Obx(() {
          final profile = profileController.userProfile.value;
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profile),
            child: Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                    ? Image.network(
                        profile.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildProfileCompletionBanner(ProfileController controller, int completion) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.deepOrange.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutes.profile),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Complete Your Profile',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add health info for AI recommendations',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: completion / 100,
                                        minHeight: 6,
                                        backgroundColor: Colors.white.withOpacity(0.3),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '$completion%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}