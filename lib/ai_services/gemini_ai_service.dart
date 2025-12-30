// lib/services/ai_services/gemini_ai_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/ai_models.dart';
import 'ai_prompts.dart';

/// Gemini AI Service for nutrition analysis and health recommendations
class GeminiAIService extends GetxService {
  static GeminiAIService get instance => Get.find<GeminiAIService>();

  late final GenerativeModel _nutritionModel;
  late final GenerativeModel _healthModel;
  

   // Load API key from environment variables
  late final String _apiKey;

  @override
  void onInit() {
    super.onInit();
    _loadApiKey();
    _initializeModels();
  }

  /// Load API key from .env file
  void _loadApiKey() {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    
    if (_apiKey.isEmpty) {
      log('❌ ERROR: GEMINI_API_KEY not found in .env file!');
      log('   Please add your API key to the .env file');
    } else {
      log('✅ API Key loaded successfully');
      // Only log first few characters for security
      log('   Key preview: ${_apiKey.substring(0, 10)}...');
    }
  }

  void _initializeModels() {
    // Initialize nutrition analysis model
    _nutritionModel = GenerativeModel(
      model: 'gemini-1.5-flash', // Fast model for quick responses
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.2, // Low temperature for consistent, factual responses
        topK: 20,
        topP: 0.8,
        maxOutputTokens: 2048,
      ),
      systemInstruction: Content.system(AIPrompts.nutritionSystemRole),
    );

    // Initialize health recommendation model
    _healthModel = GenerativeModel(
      model: 'gemini-1.5-pro', // Pro model for complex reasoning
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4, // Slightly higher for creative recommendations
        topK: 40,
        topP: 0.9,
        maxOutputTokens: 3072,
      ),
      systemInstruction: Content.system(AIPrompts.healthSystemRole),
    );
  }

  // ==================== Nutrition Analysis ====================

  /// Analyze recipe and get nutritional information
  Future<NutritionData?> analyzeNutrition({
    required String recipeName,
    required List<String> ingredients,
    required List<String> quantities,
  }) async {
    try {
      log('🤖 AI: Analyzing nutrition for: $recipeName');

      final prompt = AIPrompts.getNutritionPrompt(
        recipeName: recipeName,
        ingredients: ingredients,
        quantities: quantities,
      );

      final response = await _nutritionModel.generateContent([
        Content.text(prompt),
      ]);

      if (response.text == null) {
        log('⚠️ AI: No response from Gemini');
        return null;
      }

      log('📊 AI Response received: ${response.text!.substring(0, 100)}...');

      // Clean and parse JSON response
      final cleanedJson = _cleanJsonResponse(response.text!);
      final jsonData = jsonDecode(cleanedJson) as Map<String, dynamic>;

      final nutritionData = NutritionData.fromJson(jsonData);
      
      log('✅ AI: Successfully parsed nutrition data');
      log('   Calories: ${nutritionData.caloriesPerServing}');
      log('   Health Score: ${nutritionData.healthScore}');

      return nutritionData;
    } catch (e, stackTrace) {
      log('❌ AI Error analyzing nutrition: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  // ==================== Health Recommendations ====================

  /// Get health-based recommendations for a recipe
  Future<HealthRecommendation?> getHealthRecommendations({
    required String recipeName,
    required Map<String, dynamic> nutritionData,
    String? userHealthCondition,
    List<String>? dietaryRestrictions,
    List<String>? allergies,
  }) async {
    try {
      log('🤖 AI: Getting health recommendations for: $recipeName');

      final prompt = AIPrompts.getHealthRecommendationPrompt(
        recipeName: recipeName,
        nutritionData: nutritionData,
        userHealthCondition: userHealthCondition,
        dietaryRestrictions: dietaryRestrictions,
        allergies: allergies,
      );

      final response = await _healthModel.generateContent([
        Content.text(prompt),
      ]);

      if (response.text == null) {
        log('⚠️ AI: No response from Gemini');
        return null;
      }

      log('🏥 AI Response received');

      // Clean and parse JSON response
      final cleanedJson = _cleanJsonResponse(response.text!);
      final jsonData = jsonDecode(cleanedJson) as Map<String, dynamic>;

      final recommendation = HealthRecommendation.fromJson(jsonData);
      
      log('✅ AI: Successfully parsed health recommendations');
      log('   Overall Rating: ${recommendation.overallRating}');
      log('   Suitable: ${recommendation.recommendations.suitable}');

      return recommendation;
    } catch (e, stackTrace) {
      log('❌ AI Error getting recommendations: $e');
      log('Stack trace: $stackTrace');
      return null;
    }
  }

  // ==================== Helper Methods ====================

  /// Clean JSON response by removing markdown code blocks and extra text
  String _cleanJsonResponse(String response) {
    // Remove markdown code blocks
    String cleaned = response
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    // Find the first { and last }
    final startIndex = cleaned.indexOf('{');
    final endIndex = cleaned.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1) {
      cleaned = cleaned.substring(startIndex, endIndex + 1);
    }

    return cleaned;
  }

  /// Check if API key is configured
  bool isConfigured() {
    return _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY_HERE';
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final response = await _nutritionModel.generateContent([
        Content.text('Return only the text "OK" if you can read this'),
      ]);
      return response.text?.contains('OK') ?? false;
    } catch (e) {
      log('❌ AI: Connection test failed: $e');
      return false;
    }
  }

  // ==================== Caching (Optional Enhancement) ====================

  final Map<String, NutritionData> _nutritionCache = {};
  final Map<String, HealthRecommendation> _healthCache = {};

  /// Get cached nutrition data
  NutritionData? getCachedNutrition(String recipeId) {
    return _nutritionCache[recipeId];
  }

  /// Cache nutrition data
  void cacheNutrition(String recipeId, NutritionData data) {
    _nutritionCache[recipeId] = data;
  }

  /// Get cached health recommendation
  HealthRecommendation? getCachedHealth(String recipeId) {
    return _healthCache[recipeId];
  }

  /// Cache health recommendation
  void cacheHealth(String recipeId, HealthRecommendation data) {
    _healthCache[recipeId] = data;
  }

  /// Clear all caches
  void clearCache() {
    _nutritionCache.clear();
    _healthCache.clear();
  }
}