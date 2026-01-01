// lib/pages/all_favourites_page/controller/all_favourites_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/services/database_services/database.dart';
import 'package:recipe_book/services/database_services/meal.dart';

enum SortOption {
  dateAdded('Recently Added'),
  alphabetical('A to Z'),
  reverseAlphabetical('Z to A');

  const SortOption(this.displayName);
  final String displayName;
}

class AllFavouritesController extends GetxController {
  final DBHelper _db = DBHelper();

  // Observable lists
  final RxList<Meal> favourites = <Meal>[].obs;
  final RxList<Meal> filteredFavourites = <Meal>[].obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Sort option
  final Rx<SortOption> currentSort = SortOption.dateAdded.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }

  /// Load all favourites from database
  void loadFavourites() {
    try {
      isLoading.value = true;
      
      final fetchedFavourites = _db.favouriteMeals();
      
      favourites.value = fetchedFavourites;
      filteredFavourites.value = fetchedFavourites;
      
      // Apply current sort
      _applySorting();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load favourites: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFFF6B6B),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Search favourites by name
  void searchFavourites(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredFavourites.value = favourites;
    } else {
      filteredFavourites.value = favourites
          .where((meal) =>
              meal.strMeal.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    
    // Reapply sorting after search
    _applySorting();
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredFavourites.value = favourites;
    _applySorting();
  }

  /// Apply sorting to filtered favourites
  void _applySorting() {
    switch (currentSort.value) {
      case SortOption.dateAdded:
        // Default order (most recent first if your DB supports it)
        // If not, reverse the list
        filteredFavourites.value = filteredFavourites.reversed.toList();
        break;
        
      case SortOption.alphabetical:
        filteredFavourites.sort((a, b) => 
          a.strMeal.toLowerCase().compareTo(b.strMeal.toLowerCase())
        );
        break;
        
      case SortOption.reverseAlphabetical:
        filteredFavourites.sort((a, b) => 
          b.strMeal.toLowerCase().compareTo(a.strMeal.toLowerCase())
        );
        break;
    }
  }

  /// Show sort options bottom sheet
  void showSortOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            
            // Sort options
            ...SortOption.values.map((option) => Obx(() {
              final isSelected = currentSort.value == option;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey,
                ),
                title: Text(
                  option.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? const Color(0xFFFF6B6B) : Colors.grey[800],
                  ),
                ),
                onTap: () {
                  currentSort.value = option;
                  _applySorting();
                  Get.back();
                },
              );
            })),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  /// Navigate to recipe page
  void navigateToRecipe(Meal meal) {
    Get.toNamed('/recipe', arguments: meal)?.then((_) {
      // Refresh favourites when returning from recipe page
      refreshFavourites();
    });
  }

  /// Remove favourite with confirmation
  void removeFavourite(Meal meal) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.favorite_border, color: Color(0xFFFF6B6B)),
            SizedBox(width: 12),
            Text('Remove Favourite?'),
          ],
        ),
        content: Text(
          'Do you want to remove "${meal.strMeal}" from your favourites?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _db.delete(meal.idMeal);
              loadFavourites();
              Get.back();
              
              Get.snackbar(
                'Removed',
                '${meal.strMeal} removed from favourites',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
                backgroundColor: const Color(0xFF4CAF50),
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
                borderRadius: 10,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  /// Refresh favourites
  Future<void> refreshFavourites() async {
    loadFavourites();
  }

  @override
  void onClose() {
    super.onClose();
  }
}