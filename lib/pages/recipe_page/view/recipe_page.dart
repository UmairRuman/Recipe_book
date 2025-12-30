// lib/pages/recipe_page/view/recipe_page.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/ai_controller.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';

import 'package:recipe_book/services/database_services/meal.dart';
import 'package:recipe_book/services/recipe_service/view/widgets/health_advice_bottom_sheet.dart';
import 'package:recipe_book/services/recipe_service/view/widgets/nutrition_bottom_sheet.dart';

class RecipePage extends GetView<RecipeController> {
  const RecipePage({super.key, this.selectedNotificationMeal});
  final Meal? selectedNotificationMeal;
  static const pageAddress = '/recipe';
  static const instructions = 'Instructions';
  static const originalRecipeLink = 'Recipe link :';
  static const youtubeIconSize = 18.0;
  static const youtubeImage = 'assets/images/youtube.png';

  @override
  Widget build(BuildContext context) {
    final Meal meal;
    if (selectedNotificationMeal != null) {
      meal = selectedNotificationMeal!;
    } else {
      meal = Get.arguments;
    }
    controller.checkForFavouriteIcon(meal);
    
    // Get AI Controller
    final aiController = AIController.instance;
    
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFFAFBFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced SliverAppBar with hero image
          SliverAppBar(
            expandedHeight: height * 0.45,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: _buildGlassmorphicButton(
              icon: Icons.arrow_back_ios,
              onTap: () {
                HapticFeedback.lightImpact();
                controller.navigateBackToCategoryPage();
              },
            ),
            actions: [
              _buildGlassmorphicButton(
                icon: Icons.timer_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.scheduleNotification(context, meal);
                },
              ),
              _buildGlassmorphicButton(
                child: Image.asset(youtubeImage, height: youtubeIconSize),
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.openYoutubeVideo(context, meal.strYoutube);
                },
              ),
              _buildGlassmorphicButton(
                child: Obx(() => controller.favouriteIcon.value),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  controller.onFavouriteIconTap(meal);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image with parallax effect
                  Hero(
                    tag: 'recipe-${meal.idMeal}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(meal.strMealThumb),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // Title with glassmorphic background
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Text(
                            meal.strMeal,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Floating decorative elements
                  ...List.generate(3, (index) {
                    return Positioned(
                      top: 80 + (index * 100),
                      right: -30 + (index * 20),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.orange.withOpacity(0.2),
                              Colors.red.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Main content with enhanced design
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // ==================== AI FEATURES SECTION ====================
                  _buildAIFeaturesSection(context, meal, aiController, isDarkMode),

                  const SizedBox(height: 30),

                  // Enhanced ingredients section
                  _buildSectionHeader('Ingredients', Icons.restaurant_menu),

                  // Improved ingredients list
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors:
                            isDarkMode
                                ? [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ]
                                : [
                                  const Color(0xFFF8F9FA),
                                  const Color(0xFFE9ECEF).withOpacity(0.5),
                                ],
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: EnhancedIngredientsQuantityList(
                        ingredientsAndQuantityList: controller
                            .ingredientsAndQuantityList(meal.toMap()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Enhanced instructions section
                  _buildSectionHeader('Instructions', Icons.list_alt),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors:
                            isDarkMode
                                ? [
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.02),
                                ]
                                : [
                                  Colors.white,
                                  const Color(0xFFF8F9FA).withOpacity(0.8),
                                ],
                      ),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      meal.strInstructions,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.9)
                                : Colors.black87,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Enhanced link widget
                  if (meal.strSource != null)
                    EnhancedLinkWidget(source: meal.strSource!),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== AI FEATURES SECTION ====================
  
  Widget _buildAIFeaturesSection(
    BuildContext context,
    Meal meal,
    AIController aiController,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI-Powered Insights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // AI feature buttons
          Row(
            children: [
              // Nutrition Facts Button
              Expanded(
                child: _buildAIFeatureButton(
                  context: context,
                  icon: Icons.restaurant_menu,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                  ),
                  label: 'Nutrition\nFacts',
                  isDarkMode: isDarkMode,
                  onTap: () => _showNutritionBottomSheet(context, meal, aiController),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Health Advice Button
              Expanded(
                child: _buildAIFeatureButton(
                  context: context,
                  icon: Icons.favorite,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFF44336)],
                  ),
                  label: 'Health\nAdvice',
                  isDarkMode: isDarkMode,
                  onTap: () => _showHealthAdviceBottomSheet(context, meal, aiController),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeatureButton({
    required BuildContext context,
    required IconData icon,
    required Gradient gradient,
    required String label,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Nutrition Bottom Sheet
  void _showNutritionBottomSheet(
    BuildContext context,
    Meal meal,
    AIController aiController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NutritionBottomSheet(
        meal: meal,
        aiController: aiController,
      ),
    );
  }

  // Show Health Advice Bottom Sheet
  void _showHealthAdviceBottomSheet(
    BuildContext context,
    Meal meal,
    AIController aiController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HealthAdviceBottomSheet(
        meal: meal,
        aiController: aiController,
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildGlassmorphicButton({
    IconData? icon,
    Widget? child,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: child ?? Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== EXISTING WIDGETS ====================

class EnhancedLinkWidget extends GetView<RecipeController> {
  const EnhancedLinkWidget({super.key, required this.source});
  final String source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          controller.openOriginalRecipe(context, source);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.cyan.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.link, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Original Recipe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      source,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class EnhancedIngredientsQuantityList extends StatelessWidget {
  const EnhancedIngredientsQuantityList({
super.key,
required this.ingredientsAndQuantityList,
});
final (List<String>, List<String>) ingredientsAndQuantityList;
@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final isDarkMode = theme.brightness == Brightness.dark;
return Container(
  constraints: const BoxConstraints(maxHeight: 300),
  child: ListView.separated(
    padding: const EdgeInsets.all(16),
    physics: const BouncingScrollPhysics(),
    itemCount: ingredientsAndQuantityList.$1.length,
    separatorBuilder: (context, index) => const SizedBox(height: 8),
    itemBuilder:
        (context, index) => TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.1)
                                : Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Text(
                          ingredientsAndQuantityList.$1[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color:
                                isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ingredientsAndQuantityList.$2[index],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            color: (isDarkMode
                                    ? Colors.white
                                    : Colors.black87)
                                .withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
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
);
}
}