// lib/pages/all_categories_page/controller/all_categories_controller.dart

import 'dart:ui';

import 'package:get/get.dart';
import 'package:recipe_book/pages/home_page/model/categories_list_model.dart';

import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/services/meal_services/category_service/category_service.dart';

class AllCategoriesController extends GetxController {
  final CategoriesService _categoriesService = CategoriesService();

  // Observable lists
  final RxList<CategoriesModel> categories = <CategoriesModel>[].obs;
  final RxList<CategoriesModel> filteredCategories = <CategoriesModel>[].obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load all categories from API
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      
      final fetchedCategories = await _categoriesService.fetchCategories();
      
      categories.value = fetchedCategories;
      filteredCategories.value = fetchedCategories;
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search categories by name
  void searchCategories(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) =>
              category.strCategory.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredCategories.value = categories;
  }

  /// Navigate to category page
  void navigateToCategory(String categoryName) {
    Get.toNamed(AppRoutes.category, arguments: categoryName);
  }

  /// Refresh categories (for pull-to-refresh)
  Future<void> refreshCategories() async {
    await loadCategories();
  }
  
  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}