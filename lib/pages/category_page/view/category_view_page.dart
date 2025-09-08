import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _searchController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _searchAnimation;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void rebuildPage() {
    setState(() {
      log('category page rebuilt');
    });

    // Add subtle rebuild animation
    _slideController.reset();
    _slideController.forward();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });

    if (_isSearchExpanded) {
      _searchController.forward();
      HapticFeedback.lightImpact();
    } else {
      _searchController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final List<CategoryItem> categories = Get.arguments;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    controller.iconsList.addAll(
      List.generate(
        categories.length,
        (index) => const Icon(Icons.favorite_border_outlined),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
          isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFFAFBFC),
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isDarkMode
                            ? [
                              const Color(
                                0xFF1A1A2E,
                              ).withOpacity(_fadeAnimation.value * 0.8),
                              const Color(
                                0xFF16213E,
                              ).withOpacity(_fadeAnimation.value * 0.6),
                              const Color(
                                0xFF0F3460,
                              ).withOpacity(_fadeAnimation.value * 0.4),
                            ]
                            : [
                              const Color(
                                0xFFFFFFFF,
                              ).withOpacity(_fadeAnimation.value),
                              const Color(
                                0xFFF8F9FA,
                              ).withOpacity(_fadeAnimation.value * 0.9),
                              const Color(
                                0xFFE9ECEF,
                              ).withOpacity(_fadeAnimation.value * 0.8),
                            ],
                  ),
                ),
              );
            },
          ),

          // Floating decorative elements
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Positioned(
                  top: 100 + (index * 200),
                  right: -50 + (index * 30),
                  child: Transform.rotate(
                    angle: _fadeAnimation.value * 0.5 + index,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.orange.withOpacity(0.1),
                            Colors.red.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Enhanced Header with glassmorphism
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors:
                            isDarkMode
                                ? [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ]
                                : [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.7),
                                ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // Back button with animation
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                    size: 20,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Title with enhanced typography
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recipe Categories',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      'Discover delicious recipes',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: (isDarkMode
                                                ? Colors.white
                                                : Colors.black87)
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Search toggle button
                              GestureDetector(
                                onTap: _toggleSearch,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AnimatedRotation(
                                    turns: _isSearchExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.orange,
                                      size: 24,
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

                // Animated search bar
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child:
                      _isSearchExpanded
                          ? ScaleTransition(
                            scale: _searchAnimation,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: CategorySearchBarWidget(
                                rebuildFunction: rebuildPage,
                                categoriesList: categories,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),

                const SizedBox(height: 8),

                // Enhanced category list
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                                isDarkMode
                                    ? [
                                      Colors.white.withOpacity(0.05),
                                      Colors.white.withOpacity(0.02),
                                    ]
                                    : [
                                      Colors.white.withOpacity(0.8),
                                      Colors.white.withOpacity(0.9),
                                    ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isDarkMode
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, -5),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: CategoryList(categories: categories),
                        ),
                      ),
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
}
