// lib/controllers/ai_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/ai_services/gemini_ai_service.dart';

import '../models/ai_models.dart';
import 'profile_controller.dart';

/// AI Controller for managing nutrition and health recommendation states
/// Now integrates with ProfileController for personalized recommendations
class AIController extends GetxController {
  static AIController get instance => Get.find<AIController>();

  final GeminiAIService _aiService = GeminiAIService.instance;
  
  // Get ProfileController for user health data
  ProfileController get _profileController => Get.find<ProfileController>();

  // ==================== Observables ====================

  // Nutrition Analysis State
  final Rx<NutritionData?> currentNutrition = Rx<NutritionData?>(null);
  final RxBool isLoadingNutrition = false.obs;
  final RxString nutritionError = ''.obs;

  // Health Recommendation State
  final Rx<HealthRecommendation?> currentHealthAdvice = Rx<HealthRecommendation?>(null);
  final RxBool isLoadingHealth = false.obs;
  final RxString healthError = ''.obs;

  // Cache tracking
  final RxMap<String, NutritionData> nutritionCache = <String, NutritionData>{}.obs;
  final RxMap<String, HealthRecommendation> healthCache = <String, HealthRecommendation>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAPIConfiguration();
    _listenToProfileChanges();
    log('✅ AIController initialized with profile integration');
  }

  // ==================== Profile Integration ====================

  /// Listen to profile changes and clear health cache
  void _listenToProfileChanges() {
    ever(_profileController.userProfile, (profile) {
      if (profile != null) {
        log('👤 Profile updated, clearing health cache for fresh recommendations');
        _clearHealthCache();
      }
    });
  }

  /// Get user's health conditions as string
  String? get _userHealthConditions {
    final profile = _profileController.userProfile.value;
    if (profile == null || profile.healthConditions.isEmpty) return null;
    
    return profile.healthConditions
        .map((condition) => '${condition.name} (${condition.severity})')
        .join(', ');
  }

  /// Get user's dietary restrictions
  List<String>? get _userDietaryRestrictions {
    final profile = _profileController.userProfile.value;
    if (profile == null || profile.dietaryRestrictions.isEmpty) return null;
    return profile.dietaryRestrictions;
  }

  /// Get user's allergies
  List<String>? get _userAllergies {
    final profile = _profileController.userProfile.value;
    if (profile == null || profile.allergies.isEmpty) return null;
    return profile.allergies;
  }

  /// Check if user profile is complete enough for personalized AI
  bool get isProfileReadyForAI {
    return _profileController.isProfileCompleteForAI;
  }

  // ==================== Nutrition Analysis ====================

  /// Get nutrition analysis for a recipe
  Future<void> analyzeRecipeNutrition({
    required String recipeId,
    required String recipeName,
    required List<String> ingredients,
    required List<String> quantities,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first unless force refresh
      if (!forceRefresh && nutritionCache.containsKey(recipeId)) {
        log('📦 Using cached nutrition data for: $recipeName');
        currentNutrition.value = nutritionCache[recipeId];
        return;
      }

      // Start loading
      isLoadingNutrition.value = true;
      nutritionError.value = '';
      currentNutrition.value = null;

      log('🤖 Fetching nutrition data for: $recipeName');

      // Call AI service
      final result = await _aiService.analyzeNutrition(
        recipeName: recipeName,
        ingredients: ingredients,
        quantities: quantities,
      );

      if (result != null) {
        // Success - update state and cache
        currentNutrition.value = result;
        nutritionCache[recipeId] = result;
        
        log('✅ Nutrition data received');
        log('   Calories: ${result.caloriesPerServing}');
        log('   Health Score: ${result.healthScore}');
        
        // Check for allergens if user has profile
        _checkForAllergens(recipeName, result.allergens);
      } else {
        // Failed to get data
        nutritionError.value = 'Failed to analyze nutrition. Please try again.';
        log('❌ Failed to get nutrition data');
      }
    } catch (e) {
      nutritionError.value = 'An error occurred: ${e.toString()}';
      log('❌ Error in analyzeRecipeNutrition: $e');
    } finally {
      isLoadingNutrition.value = false;
    }
  }

  // ==================== Health Recommendations ====================

  /// Get health recommendations for a recipe with user profile integration
  Future<void> getHealthRecommendations({
    required String recipeId,
    required String recipeName,
    required Map<String, dynamic> nutritionData,
    bool forceRefresh = false,
  }) async {
    try {
      // Check if profile is complete enough
      if (!isProfileReadyForAI) {
        healthError.value = 'Complete your profile (50%+) for personalized recommendations';
        _showProfileIncompleteMessage();
        return;
      }

      // Check cache first unless force refresh
      if (!forceRefresh && healthCache.containsKey(recipeId)) {
        log('📦 Using cached health advice for: $recipeName');
        currentHealthAdvice.value = healthCache[recipeId];
        return;
      }

      // Start loading
      isLoadingHealth.value = true;
      healthError.value = '';
      currentHealthAdvice.value = null;

      log('🤖 Fetching personalized health recommendations for: $recipeName');
      log('👤 User conditions: ${_userHealthConditions ?? "None"}');
      log('🥗 User restrictions: ${_userDietaryRestrictions?.join(", ") ?? "None"}');
      log('⚠️ User allergies: ${_userAllergies?.join(", ") ?? "None"}');

      // Call AI service with user profile data
      final result = await _aiService.getHealthRecommendations(
        recipeName: recipeName,
        nutritionData: nutritionData,
        userHealthCondition: _userHealthConditions,
        dietaryRestrictions: _userDietaryRestrictions,
        allergies: _userAllergies,
      );

      if (result != null) {
        // Success - update state and cache
        currentHealthAdvice.value = result;
        healthCache[recipeId] = result;
        
        log('✅ Health recommendations received');
        log('   Rating: ${result.overallRating}');
        log('   Suitable: ${result.recommendations.suitable}');
        
        // Show warning if recipe is not suitable
        if (!result.recommendations.suitable) {
          _showUnsuitableRecipeWarning(recipeName);
        }
      } else {
        // Failed to get data
        healthError.value = 'Failed to get health advice. Please try again.';
        log('❌ Failed to get health recommendations');
      }
    } catch (e) {
      healthError.value = 'An error occurred: ${e.toString()}';
      log('❌ Error in getHealthRecommendations: $e');
    } finally {
      isLoadingHealth.value = false;
    }
  }

  /// Quick check if recipe is safe for user (based on allergies)
  bool isRecipeSafeForUser(List<String> recipeAllergens) {
    final userAllergies = _userAllergies;
    if (userAllergies == null || userAllergies.isEmpty) return true;
    
    // Check if any recipe allergen matches user allergies
    for (var allergen in recipeAllergens) {
      for (var userAllergen in userAllergies) {
        if (allergen.toLowerCase().contains(userAllergen.toLowerCase()) ||
            userAllergen.toLowerCase().contains(allergen.toLowerCase())) {
          return false;
        }
      }
    }
    return true;
  }

  // ==================== Allergy Checking ====================

  /// Check recipe allergens against user profile
  void _checkForAllergens(String recipeName, List<String> recipeAllergens) {
    final userAllergies = _userAllergies;
    if (userAllergies == null || userAllergies.isEmpty) return;
    
    final foundAllergens = <String>[];
    
    for (var allergen in recipeAllergens) {
      for (var userAllergen in userAllergies) {
        if (allergen.toLowerCase().contains(userAllergen.toLowerCase()) ||
            userAllergen.toLowerCase().contains(allergen.toLowerCase())) {
          foundAllergens.add(allergen);
        }
      }
    }
    
    if (foundAllergens.isNotEmpty) {
      Get.snackbar(
        '⚠️ Allergy Warning',
        '$recipeName contains: ${foundAllergens.join(", ")}',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.warning_amber, color: Colors.white),
      );
    }
  }

  // ==================== User Feedback ====================

  /// Show message when profile is incomplete
  void _showProfileIncompleteMessage() {
    Get.snackbar(
      '📝 Complete Your Profile',
      'Add health information for personalized AI recommendations',
      backgroundColor: Colors.orange.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      mainButton: TextButton(
        onPressed: () {
          Get.toNamed('/profile');
        },
        child: const Text(
          'Complete Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Show warning when recipe is not suitable
  void _showUnsuitableRecipeWarning(String recipeName) {
    Get.snackbar(
      '⚠️ Health Advisory',
      'This recipe may not be suitable for your health conditions. Check recommendations.',
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // ==================== Cache Management ====================

  /// Clear only health cache (when user profile changes)
  void _clearHealthCache() {
    healthCache.clear();
    currentHealthAdvice.value = null;
    log('🗑️ Health cache cleared due to profile update');
  }

  /// Clear all caches
  void clearAllCaches() {
    nutritionCache.clear();
    healthCache.clear();
    currentNutrition.value = null;
    currentHealthAdvice.value = null;
    _aiService.clearCache();
    log('🗑️ All caches cleared');
  }

  /// Get cached nutrition data
  NutritionData? getCachedNutrition(String recipeId) {
    return nutritionCache[recipeId];
  }

  /// Get cached health recommendation
  HealthRecommendation? getCachedHealth(String recipeId) {
    return healthCache[recipeId];
  }

  // ==================== Helper Methods ====================

  /// Check if API is properly configured
  void _checkAPIConfiguration() {
    if (!_aiService.isConfigured()) {
      log('⚠️ WARNING: Gemini API key not configured!');
      log('   Please add your API key to .env file');
    } else {
      log('✅ Gemini API configured');
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    final result = await _aiService.testConnection();
    if (result) {
      log('✅ API connection successful');
      Get.snackbar(
        '✅ Connected',
        'AI service is ready',
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } else {
      log('❌ API connection failed');
      Get.snackbar(
        '❌ Connection Failed',
        'Please check your API key',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
    return result;
  }

  /// Reset current analysis states
  void resetCurrentStates() {
    currentNutrition.value = null;
    currentHealthAdvice.value = null;
    nutritionError.value = '';
    healthError.value = '';
    isLoadingNutrition.value = false;
    isLoadingHealth.value = false;
  }

  /// Check if nutrition data is available for a recipe
  bool hasNutritionData(String recipeId) {
    return nutritionCache.containsKey(recipeId);
  }

  /// Check if health advice is available for a recipe
  bool hasHealthAdvice(String recipeId) {
    return healthCache.containsKey(recipeId);
  }

  /// Get profile completion percentage
  int get profileCompletion => _profileController.profileCompletion.value;

  /// Get health summary for display
  String get userHealthSummary => _profileController.healthSummary;

  @override
  void onClose() {
    clearAllCaches();
    super.onClose();
    log('🔄 AIController disposed');
  }
}