import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';

class EnhancedCategoryItemView extends StatefulWidget {
  const EnhancedCategoryItemView({
    super.key,
    required this.category,
    required this.index,
    required this.animationValue,
  });

  final CategoryItem category;
  final int index;
  final double animationValue;

  @override
  State<EnhancedCategoryItemView> createState() =>
      _EnhancedCategoryItemViewState();
}

class _EnhancedCategoryItemViewState extends State<EnhancedCategoryItemView>
    with TickerProviderStateMixin {
  final controller = Get.find<CategoryController>();
  late AnimationController _hoverController;
  late AnimationController _favoriteController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _favoriteAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  void rebuildPage() => setState(() {});

  void _onBtnTap() {
    HapticFeedback.mediumImpact();
    controller.navigateToRecipePage(
      widget.category.strMeal,
      widget.index,
      rebuildPage,
    );
  }

  void _onFavoriteTap() {
    HapticFeedback.lightImpact();
    _favoriteController.forward().then((_) {
      _favoriteController.reverse();
    });
    controller.onFavouriteIconTap(widget.category, widget.index);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => controller.checkForFavouriteIcon(
        widget.category.idMeal,
        widget.index,
      ),
    );

    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: GestureDetector(
              onTap: _onBtnTap,
              child: Container(
                height: height * 0.35,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isDarkMode
                            ? [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ]
                            : [Colors.white, const Color(0xFFF8F9FA)],
                  ),
                  border: Border.all(
                    color:
                        _isHovered
                            ? Colors.orange.withOpacity(0.3)
                            : Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.08),
                      blurRadius: _isHovered ? 25 : 15,
                      offset: Offset(0, _isHovered ? 15 : 8),
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Stack(
                      children: [
                        // Background gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),

                        // Main content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Header with favorite button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Recipe category indicator
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.deepOrange,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Recipe',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  // Enhanced favorite button
                                  AnimatedBuilder(
                                    animation: _favoriteAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _favoriteAnimation.value,
                                        child: GestureDetector(
                                          onTap: _onFavoriteTap,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Obx(
                                              () =>
                                                  controller.iconsList[widget
                                                      .index],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Enhanced hero image
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Hero(
                                    tag: 'recipe-${widget.category.idMeal}',
                                    child: Container(
                                      width: height * 0.15,
                                      height: height * 0.15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orange.withOpacity(0.3),
                                            Colors.red.withOpacity(0.2),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                widget.category.strMealThumb,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Enhanced recipe title
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.category.strMeal.length > 20
                                          ? '${widget.category.strMeal.substring(0, 20)}...'
                                          : widget.category.strMeal,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                        height: 0.3,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Cooking time indicator (mock data)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: (isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87)
                                              .withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${15 + (widget.index % 30)} min',
                                          style: TextStyle(
                                            color: (isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87)
                                                .withOpacity(0.6),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Enhanced action button
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors:
                                        _isHovered
                                            ? [Colors.deepOrange, Colors.red]
                                            : [
                                              Colors.orange,
                                              Colors.deepOrange,
                                            ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.4),
                                      blurRadius: _isHovered ? 15 : 10,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _onBtnTap,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'View Recipe',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floating decorative element
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.orange.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
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
}

// Legacy CategoryItemView for backward compatibility (if needed)
class CategoryItemView extends StatefulWidget {
  const CategoryItemView({
    super.key,
    required this.category,
    required this.index,
  });

  final CategoryItem category;
  final int index;
  static const shadows = [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 20,
      spreadRadius: 5,
      offset: Offset(3, 3),
    ),
  ];
  static const recipeNamePaddingFromTop = 0.3;
  static const recipeNamePaddingFromLeft = 0.05;
  static const favIconSpacingFromTop = 0.1;
  static const favIconSpacingFromRight = 0.08;
  static const avatarRadius = 0.08;
  static const btnText = 'See Recipe';

  @override
  State<CategoryItemView> createState() => _CategoryItemViewState();
}

class _CategoryItemViewState extends State<CategoryItemView> {
  final controller = Get.find<CategoryController>();
  void rebuildPage() => setState(() {});

  void _onBtnTap() {
    controller.navigateToRecipePage(
      widget.category.strMeal,
      widget.index,
      rebuildPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return the enhanced version instead of the old design
    return EnhancedCategoryItemView(
      category: widget.category,
      index: widget.index,
      animationValue: 1.0,
    );
  }
}
