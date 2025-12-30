// lib/pages/recipe_page/view/widgets/nutrition_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/ai_controller.dart';
import 'package:recipe_book/models/ai_models.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:shimmer/shimmer.dart';

class NutritionBottomSheet extends StatefulWidget {
  const NutritionBottomSheet({
    super.key,
    required this.meal,
    required this.aiController,
  });

  final Meal meal;
  final AIController aiController;

  @override
  State<NutritionBottomSheet> createState() => _NutritionBottomSheetState();
}

class _NutritionBottomSheetState extends State<NutritionBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    // Fetch nutrition data if not cached
    _fetchNutritionData();
  }

  void _fetchNutritionData() async {
    final recipeController = Get.find<RecipeController>();
    final ingredientsAndQuantity =
        recipeController.ingredientsAndQuantityList(widget.meal.toMap());

    await widget.aiController.analyzeRecipeNutrition(
      recipeId: widget.meal.idMeal,
      recipeName: widget.meal.strMeal,
      ingredients: ingredientsAndQuantity.$1,
      quantities: ingredientsAndQuantity.$2,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, size.height * 0.1 * _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              height: size.height * 0.85,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  _buildHeader(isDarkMode),

                  // Content
                  Expanded(
                    child: Obx(() {
                      if (widget.aiController.isLoadingNutrition.value) {
                        return _buildLoadingState(isDarkMode);
                      }

                      if (widget.aiController.nutritionError.value.isNotEmpty) {
                        return _buildErrorState(
                          isDarkMode,
                          widget.aiController.nutritionError.value,
                        );
                      }

                      final nutrition = widget.aiController.currentNutrition.value;
                      if (nutrition == null) {
                        return _buildEmptyState(isDarkMode);
                      }

                      return _buildNutritionContent(nutrition, isDarkMode);
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu,
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
                  'Nutrition Analysis',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-Powered Breakdown',
                  style: TextStyle(
                    fontSize: 14,
                    color: (isDarkMode ? Colors.white : Colors.black87)
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor:
                isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor:
                isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 200,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Analyzing nutrition...',
            style: TextStyle(
              fontSize: 16,
              color:
                  (isDarkMode ? Colors.white : Colors.black87).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color:
                    (isDarkMode ? Colors.white : Colors.black87).withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _fetchNutritionData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color:
                (isDarkMode ? Colors.white : Colors.black87).withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent(NutritionData nutrition, bool isDarkMode) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${nutrition.caloriesPerServing}',
                  unit: 'kcal',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOverviewCard(
                  icon: Icons.favorite,
                  label: 'Health Score',
                  value: '${nutrition.healthScore}',
                  unit: '/100',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                  ),
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Macronutrients Breakdown
          _buildSectionTitle('Macronutrients', Icons.pie_chart, isDarkMode),
          const SizedBox(height: 16),
          _buildMacroChart(nutrition, isDarkMode),

          const SizedBox(height: 30),

          // Detailed Breakdown
          _buildSectionTitle('Detailed Breakdown', Icons.analytics, isDarkMode),
          const SizedBox(height: 16),
          _buildDetailedBreakdown(nutrition, isDarkMode),

          const SizedBox(height: 30),

          // Allergens
          if (nutrition.allergens.isNotEmpty) ...[
            _buildSectionTitle('Allergens', Icons.warning_amber, isDarkMode),
            const SizedBox(height: 16),
            _buildAllergenChips(nutrition.allergens, isDarkMode),
            const SizedBox(height: 30),
          ],

          // Dietary Flags
          if (nutrition.dietaryFlags.isNotEmpty) ...[
            _buildSectionTitle('Dietary Information', Icons.info_outline, isDarkMode),
            const SizedBox(height: 16),
            _buildDietaryFlags(nutrition.dietaryFlags, isDarkMode),
            const SizedBox(height: 30),
          ],

          // Confidence Badge
          _buildConfidenceBadge(nutrition.confidence, isDarkMode),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Gradient gradient,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF4CAF50),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroChart(NutritionData nutrition, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Progress bars
          _buildMacroBar(
            'Carbs',
            nutrition.macroBreakdown.carbsPercent,
            const Color(0xFF2196F3),
            isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildMacroBar(
            'Fat',
            nutrition.macroBreakdown.fatPercent,
            const Color(0xFFFF9800),
            isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildMacroBar(
            'Protein',
            nutrition.macroBreakdown.proteinPercent,
            const Color(0xFF4CAF50),
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(
    String label,
    int percentage,
    Color color,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: percentage / 100),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedBreakdown(NutritionData nutrition, bool isDarkMode) {
    final items = [
      ('Protein', '${nutrition.nutrition.protein.toStringAsFixed(1)}g', Icons.fitness_center),
      ('Carbohydrates', '${nutrition.nutrition.carbohydrates.toStringAsFixed(1)}g', Icons.grain),
      ('Fat', '${nutrition.nutrition.fat.toStringAsFixed(1)}g', Icons.water_drop),
      ('Fiber', '${nutrition.nutrition.fiber.toStringAsFixed(1)}g', Icons.spa),
      ('Sugar', '${nutrition.nutrition.sugar.toStringAsFixed(1)}g', Icons.cake),
      ('Sodium', '${nutrition.nutrition.sodium.toStringAsFixed(0)}mg', Icons.science),
      ('Cholesterol', '${nutrition.nutrition.cholesterol.toStringAsFixed(0)}mg', Icons.favorite_border),
      ('Saturated Fat', '${nutrition.nutrition.saturatedFat.toStringAsFixed(1)}g', Icons.opacity),
    ];

    return Container(
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.withOpacity(0.1),
          height: 24,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.$3,
                  size: 18,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.$1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Text(
                item.$2,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAllergenChips(List<String> allergens, bool isDarkMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allergens.map((allergen) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                allergen.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDietaryFlags(List<String> flags, bool isDarkMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flags.map((flag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                flag.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConfidenceBadge(double confidence, bool isDarkMode) {
    final percentage = (confidence * 100).toInt();
    final color = confidence >= 0.8
        ? Colors.green
        : confidence >= 0.6
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Confidence',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        (isDarkMode ? Colors.white : Colors.black87)
                            .withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percentage% Accuracy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}