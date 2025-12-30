// lib/controllers/ai_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/ai_services/gemini_ai_service.dart';
import '../models/ai_models.dart';


/// AI Controller for managing nutrition and health recommendation states
class AIController extends GetxController {
  static AIController get instance => Get.find<AIController>();

  final GeminiAIService _aiService = GeminiAIService.instance;

  // ==================== Observables ====================

  // Nutrition Analysis State
  final Rx<NutritionData?> currentNutrition = Rx<NutritionData?>(null);
  final RxBool isLoadingNutrition = false.obs;
  final RxString nutritionError = ''.obs;

  // Health Recommendation State
  final Rx<HealthRecommendation?> currentHealthAdvice = Rx<HealthRecommendation?>(null);
  final RxBool isLoadingHealth = false.obs;
  final RxString healthError = ''.obs;

  // User Health Profile (for personalization)
  final RxString userHealthCondition = 'General Health'.obs;
  final RxList<String> dietaryRestrictions = <String>[].obs;
  final RxList<String> allergies = <String>[].obs;

  // Cache tracking
  final RxMap<String, NutritionData> nutritionCache = <String, NutritionData>{}.obs;
  final RxMap<String, HealthRecommendation> healthCache = <String, HealthRecommendation>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAPIConfiguration();
    log('✅ AIController initialized');
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

  /// Get health recommendations for a recipe
  Future<void> getHealthRecommendations({
    required String recipeId,
    required String recipeName,
    required Map<String, dynamic> nutritionData,
    bool forceRefresh = false,
  }) async {
    try {
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

      log('🤖 Fetching health recommendations for: $recipeName');

      // Call AI service with user profile
      final result = await _aiService.getHealthRecommendations(
        recipeName: recipeName,
        nutritionData: nutritionData,
        userHealthCondition: userHealthCondition.value,
        dietaryRestrictions: dietaryRestrictions.isEmpty ? null : dietaryRestrictions,
        allergies: allergies.isEmpty ? null : allergies,
      );

      if (result != null) {
        // Success - update state and cache
        currentHealthAdvice.value = result;
        healthCache[recipeId] = result;
        
        log('✅ Health recommendations received');
        log('   Rating: ${result.overallRating}');
        log('   Suitable: ${result.recommendations.suitable}');
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

  // ==================== User Profile Management ====================

  /// Update user health condition
  void updateHealthCondition(String condition) {
    userHealthCondition.value = condition;
    _clearHealthCache(); // Clear cache to get updated recommendations
    log('👤 Health condition updated: $condition');
  }

  /// Add dietary restriction
  void addDietaryRestriction(String restriction) {
    if (!dietaryRestrictions.contains(restriction)) {
      dietaryRestrictions.add(restriction);
      _clearHealthCache();
      log('🥗 Dietary restriction added: $restriction');
    }
  }

  /// Remove dietary restriction
  void removeDietaryRestriction(String restriction) {
    dietaryRestrictions.remove(restriction);
    _clearHealthCache();
    log('🥗 Dietary restriction removed: $restriction');
  }

  /// Add allergy
  void addAllergy(String allergy) {
    if (!allergies.contains(allergy)) {
      allergies.add(allergy);
      _clearHealthCache();
      log('⚠️ Allergy added: $allergy');
    }
  }

  /// Remove allergy
  void removeAllergy(String allergy) {
    allergies.remove(allergy);
    _clearHealthCache();
    log('⚠️ Allergy removed: $allergy');
  }

  // ==================== Cache Management ====================

  /// Clear only health cache (when user profile changes)
  void _clearHealthCache() {
    healthCache.clear();
    currentHealthAdvice.value = null;
    log('🗑️ Health cache cleared');
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
      log('   Please add your API key in gemini_ai_service.dart');
    } else {
      log('✅ Gemini API configured');
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    final result = await _aiService.testConnection();
    if (result) {
      log('✅ API connection successful');
    } else {
      log('❌ API connection failed');
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

  @override
  void onClose() {
    clearAllCaches();
    super.onClose();
    log('🔄 AIController disposed');
  }
}