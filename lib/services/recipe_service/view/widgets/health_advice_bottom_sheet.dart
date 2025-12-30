// lib/pages/recipe_page/view/widgets/health_advice_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_book/controllers/ai_controller.dart';
import 'package:recipe_book/models/ai_models.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/services/database_services/meal.dart';
import 'package:shimmer/shimmer.dart';

class HealthAdviceBottomSheet extends StatefulWidget {
  const HealthAdviceBottomSheet({
    super.key,
    required this.meal,
    required this.aiController,
  });

  final Meal meal;
  final AIController aiController;

  @override
  State<HealthAdviceBottomSheet> createState() =>
      _HealthAdviceBottomSheetState();
}

class _HealthAdviceBottomSheetState extends State<HealthAdviceBottomSheet>
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

    // Fetch health advice
    _fetchHealthAdvice();
  }

  void _fetchHealthAdvice() async {
    // First, ensure we have nutrition data
    final recipeController = Get.find<RecipeController>();
    final ingredientsAndQuantity =
        recipeController.ingredientsAndQuantityList(widget.meal.toMap());

    // Get or fetch nutrition data
    NutritionData? nutritionData =
        widget.aiController.getCachedNutrition(widget.meal.idMeal);

    if (nutritionData == null) {
      await widget.aiController.analyzeRecipeNutrition(
        recipeId: widget.meal.idMeal,
        recipeName: widget.meal.strMeal,
        ingredients: ingredientsAndQuantity.$1,
        quantities: ingredientsAndQuantity.$2,
      );
      nutritionData = widget.aiController.currentNutrition.value;
    }

    // Now get health recommendations
    if (nutritionData != null) {
      await widget.aiController.getHealthRecommendations(
        recipeId: widget.meal.idMeal,
        recipeName: widget.meal.strMeal,
        nutritionData: nutritionData.toJson(),
      );
    }
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
                      if (widget.aiController.isLoadingHealth.value ||
                          widget.aiController.isLoadingNutrition.value) {
                        return _buildLoadingState(isDarkMode);
                      }

                      if (widget.aiController.healthError.value.isNotEmpty) {
                        return _buildErrorState(
                          isDarkMode,
                          widget.aiController.healthError.value,
                        );
                      }

                      final healthAdvice =
                          widget.aiController.currentHealthAdvice.value;
                      if (healthAdvice == null) {
                        return _buildEmptyState(isDarkMode);
                      }

                      return _buildHealthContent(healthAdvice, isDarkMode);
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
colors: [Color(0xFFE91E63), Color(0xFFF44336)],
),
borderRadius: BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: const Color(0xFFE91E63).withOpacity(0.3),
blurRadius: 8,
offset: const Offset(0, 4),
),
],
),
child: const Icon(
Icons.favorite,
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
'Health Analysis',
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
const SizedBox(height: 4),
Text(
'Personalized Recommendations',
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
'Getting personalized advice...',
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
_fetchHealthAdvice();
},
icon: const Icon(Icons.refresh),
label: const Text('Try Again'),
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE91E63),
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
Icons.favorite_border,
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
Widget _buildHealthContent(
HealthRecommendation health,
bool isDarkMode,
) {
return SingleChildScrollView(
physics: const BouncingScrollPhysics(),
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Overall Rating Card
_buildOverallRatingCard(health, isDarkMode),
      const SizedBox(height: 30),

      // Benefits Section
      if (health.recommendations.benefits.isNotEmpty) ...[
        _buildSectionTitle('Health Benefits', Icons.check_circle, isDarkMode),
        const SizedBox(height: 16),
        ...health.recommendations.benefits.map(
          (benefit) => _buildBenefitCard(benefit, isDarkMode),
        ),
        const SizedBox(height: 30),
      ],

      // Concerns Section
      if (health.recommendations.concerns.isNotEmpty) ...[
        _buildSectionTitle('Considerations', Icons.warning_amber, isDarkMode),
        const SizedBox(height: 16),
        ...health.recommendations.concerns.map(
          (concern) => _buildConcernCard(concern, isDarkMode),
        ),
        const SizedBox(height: 30),
      ],

      // Modifications Section
      if (health.recommendations.modifications.isNotEmpty) ...[
        _buildSectionTitle(
          'Suggested Modifications',
          Icons.edit_note,
          isDarkMode,
        ),
        const SizedBox(height: 16),
        ...health.recommendations.modifications.map(
          (mod) => _buildModificationCard(mod, isDarkMode),
        ),
        const SizedBox(height: 30),
      ],

      // Personalized Advice
      _buildSectionTitle('Personalized Advice', Icons.person, isDarkMode),
      const SizedBox(height: 16),
      _buildPersonalizedAdviceCard(health.personalizedAdvice, isDarkMode),

      const SizedBox(height: 30),

      // Alternative Recipes
      if (health.alternatives.isNotEmpty) ...[
        _buildSectionTitle('Healthier Alternatives', Icons.restaurant, isDarkMode),
        const SizedBox(height: 16),
        ...health.alternatives.map(
          (alt) => _buildAlternativeCard(alt, isDarkMode),
        ),
        const SizedBox(height: 30),
      ],

      // Nutritionist Tip
      _buildNutritionistTip(health.nutritionistTip, isDarkMode),

      const SizedBox(height: 20),
    ],
  ),
);
}
Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
return Row(
children: [
Icon(
icon,
color: const Color(0xFFE91E63),
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
Widget _buildOverallRatingCard(
HealthRecommendation health,
bool isDarkMode,
) {
final ratingData = _getRatingData(health.overallRating);
return Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    gradient: ratingData.$3,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: ratingData.$3.colors.first.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Column(
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              ratingData.$2,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Rating',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ratingData.$1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${health.healthScore}/100',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              health.recommendations.suitable
                  ? Icons.check_circle
                  : Icons.cancel,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                health.recommendations.suitable
                    ? 'Suitable for your profile'
                    : 'May not be suitable for your profile',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}
(String, IconData, LinearGradient) _getRatingData(String rating) {
switch (rating.toLowerCase()) {
case 'very-healthy':
return (
'Very Healthy',
Icons.star,
const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
);
case 'healthy':
return (
'Healthy',
Icons.thumb_up,
const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF03A9F4)]),
);
case 'moderate':
return (
'Moderate',
Icons.info,
const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFB74D)]),
);
case 'caution':
return (
'Caution',
Icons.warning,
const LinearGradient(colors: [Color(0xFFFF5722), Color(0xFFFF7043)]),
);
case 'avoid':
return (
'Avoid',
Icons.cancel,
const LinearGradient(colors: [Color(0xFFF44336), Color(0xFFEF5350)]),
);
default:
return (
'Unknown',
Icons.help,
const LinearGradient(colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)]),
);
}
}
Widget _buildBenefitCard(Benefit benefit, bool isDarkMode) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color:
isDarkMode
? Colors.white.withOpacity(0.05)
: const Color(0xFFF1F8F4),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: const Color(0xFF4CAF50).withOpacity(0.2),
width: 1,
),
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: const Color(0xFF4CAF50).withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: const Icon(
Icons.check_circle,
color: Color(0xFF4CAF50),
size: 20,
),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
benefit.title,
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
const SizedBox(height: 4),
Text(
benefit.description,
style: TextStyle(
fontSize: 13,
color:
(isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.7),
height: 1.4,
),
),
],
),
),
],
),
);
}
Widget _buildConcernCard(Concern concern, bool isDarkMode) {
final severityColor = _getSeverityColor(concern.severity);
return Container(
  margin: const EdgeInsets.only(bottom: 12),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color:
        isDarkMode
            ? Colors.white.withOpacity(0.05)
            : severityColor.withOpacity(0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: severityColor.withOpacity(0.2),
      width: 1,
    ),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: severityColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.warning_amber_rounded,
          color: severityColor,
          size: 20,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    concern.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    concern.severity.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: severityColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              concern.description,
              style: TextStyle(
                fontSize: 13,
                color:
                    (isDarkMode ? Colors.white : Colors.black87)
                        .withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}
Color _getSeverityColor(String severity) {
switch (severity.toLowerCase()) {
case 'low':
return Colors.blue;
case 'moderate':
return Colors.orange;
case 'high':
return Colors.deepOrange;
case 'critical':
return Colors.red;
default:
return Colors.grey;
}
}
Widget _buildModificationCard(Modification mod, bool isDarkMode) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color:
isDarkMode
? Colors.white.withOpacity(0.05)
: const Color(0xFFFFF8E1),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: const Color(0xFFFF9800).withOpacity(0.2),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: const Color(0xFFFF9800).withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
),
child: const Icon(
Icons.swap_horiz,
color: Color(0xFFFF9800),
size: 20,
),
),
const SizedBox(width: 12),
Expanded(
child: Text(
mod.title,
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
),
],
),
const SizedBox(height: 12),
Row(
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Original',
style: TextStyle(
fontSize: 11,
color: (isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.5),
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 4),
Text(
mod.original,
style: TextStyle(
fontSize: 13,
color: isDarkMode ? Colors.white : Colors.black87,
decoration: TextDecoration.lineThrough,
),
),
],
),
),
const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFFF9800)),
const SizedBox(width: 8),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Better',
style: TextStyle(
fontSize: 11,
color: (isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.5),
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 4),
Text(
mod.replacement,
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
color: const Color(0xFF4CAF50),
),
),
],
),
),
],
),
const SizedBox(height: 12),
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color:
isDarkMode
? Colors.white.withOpacity(0.05)
: Colors.white,
borderRadius: BorderRadius.circular(8),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
mod.reason,
style: TextStyle(
fontSize: 12,
color:
(isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.7),
),
),
const SizedBox(height: 8),
Row(
children: [
const Icon(
Icons.trending_up,
size: 14,
color: Color(0xFF4CAF50),
),
const SizedBox(width: 4),
Expanded(
child: Text(
mod.impact,
style: const TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
color: Color(0xFF4CAF50),
),
),
),
],
),
],
),
),
],
),
);
}
Widget _buildPersonalizedAdviceCard(
PersonalizedAdvice advice,
bool isDarkMode,
) {
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
gradient: LinearGradient(
colors:
isDarkMode
? [
Colors.purple.withOpacity(0.2),
Colors.deepPurple.withOpacity(0.1),
]
: [
const Color(0xFFE1BEE7),
const Color(0xFFF3E5F5),
],
),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: Colors.purple.withOpacity(0.2),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: Colors.purple.withOpacity(0.2),
borderRadius: BorderRadius.circular(8),
),
child: const Icon(
Icons.person,
color: Colors.purple,
size: 20,
),
),
const SizedBox(width: 12),
Expanded(
child: Text(
'For: ${advice.forCondition}',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
),
],
),
const SizedBox(height: 16),
_buildAdviceRow(
icon: Icons.check_circle_outline,
label: 'Can Consume',
value: advice.canConsume ? 'Yes' : 'No',
valueColor: advice.canConsume ? Colors.green : Colors.red,
isDarkMode: isDarkMode,
),
_buildAdviceRow(
icon: Icons.schedule,
label: 'Frequency',
value: advice.frequency,
isDarkMode: isDarkMode,
),
_buildAdviceRow(
icon: Icons.restaurant,
label: 'Portion',
value: advice.portionAdvice,
isDarkMode: isDarkMode,
),
_buildAdviceRow(
icon: Icons.wb_sunny,
label: 'Best Time',
value: advice.bestTimeToEat,
isDarkMode: isDarkMode,
),
if (advice.pairingIdeas.isNotEmpty) ...[
const SizedBox(height: 12),
Text(
'Pair with:',
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
color:
(isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.6),
),
),
const SizedBox(height: 8),
Wrap(
spacing: 8,
runSpacing: 8,
children: advice.pairingIdeas.map((idea) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 6,
),
decoration: BoxDecoration(
color: Colors.purple.withOpacity(0.1),
borderRadius: BorderRadius.circular(8),
border: Border.all(
color: Colors.purple.withOpacity(0.3),
width: 1,
),
),
child: Text(
idea,
style: const TextStyle(
fontSize: 12,
color: Colors.purple,
fontWeight: FontWeight.w600,
),
),
);
}).toList(),
),
],
],
),
);
}
Widget _buildAdviceRow({
required IconData icon,
required String label,
required String value,
Color? valueColor,
required bool isDarkMode,
}) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Row(
children: [
Icon(
icon,
size: 16,
color: Colors.purple.withOpacity(0.7),
),
const SizedBox(width: 8),
Text(
'$label:',
style: TextStyle(
fontSize: 13,
color:
(isDarkMode ? Colors.white : Colors.black87).withOpacity(0.6),
),
),
const SizedBox(width: 8),
Expanded(
child: Text(
value,
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
color: valueColor ?? (isDarkMode ? Colors.white : Colors.black87),
),
textAlign: TextAlign.right,
),
),
],
),
);
}
Widget _buildAlternativeCard(AlternativeRecipe alt, bool isDarkMode) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(16),
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
child: Row(
children: [
Container(
width: 60,
height: 60,
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
),
borderRadius: BorderRadius.circular(12),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'${alt.calories}',
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
color: Colors.white,
height: 1,
),
),
const Text(
'cal',
style: TextStyle(
fontSize: 11,
color: Colors.white,
fontWeight: FontWeight.w600,
),
),
],
),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
alt.name,
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
const SizedBox(height: 4),
Text(
alt.reason,
style: TextStyle(
fontSize: 12,
color:
(isDarkMode ? Colors.white : Colors.black87)
.withOpacity(0.6),
height: 1.3,
),
),
],
),
),
const Icon(
Icons.arrow_forward_ios,
size: 16,
color: Color(0xFF4CAF50),
),
],
),
);
}
Widget _buildNutritionistTip(String tip, bool isDarkMode) {
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
gradient: LinearGradient(
colors:
isDarkMode
? [
Colors.blue.withOpacity(0.2),
Colors.cyan.withOpacity(0.1),
]
: [
const Color(0xFFE3F2FD),
const Color(0xFFBBDEFB).withOpacity(0.5),
],
),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: Colors.blue.withOpacity(0.2),
width: 1,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(8),
decoration: BoxDecoration(
color: Colors.blue.withOpacity(0.2),
borderRadius: BorderRadius.circular(8),
),
child: const Icon(
Icons.lightbulb,
color: Colors.blue,
size: 20,
),
),
const SizedBox(width: 12),
Text(
'Nutritionist Tip',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
color: isDarkMode ? Colors.white : Colors.black87,
),
),
],
),
const SizedBox(height: 12),
Text(
tip,
style: TextStyle(
fontSize: 14,
color:
(isDarkMode ? Colors.white : Colors.black87).withOpacity(0.8),
height: 1.5,
),
),
],
),
);
}
}