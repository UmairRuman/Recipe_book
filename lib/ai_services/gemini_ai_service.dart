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
    if (_apiKey.isEmpty) {
      log('⚠️ Cannot initialize models - API key is missing');
      return;
    }

    try {
      // Initialize nutrition analysis model
      _nutritionModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.1, // Very low for consistent JSON
          topK: 1,
          topP: 0.95,
          maxOutputTokens: 10000, // Maximum tokens for complete response
          responseMimeType: 'application/json', // Request JSON format
        ),
        systemInstruction: Content.system(AIPrompts.nutritionSystemRole),
      );

      // Initialize health recommendation model
      _healthModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          topK: 1,
          topP: 0.95,
          maxOutputTokens: 10000,
          responseMimeType: 'application/json', // Request JSON format
        ),
        systemInstruction: Content.system(AIPrompts.healthSystemRole),
      );

      log('✅ AI Models initialized successfully');
    } catch (e) {
      log('❌ Error initializing AI models: $e');
    }
  }

  // ==================== Nutrition Analysis ====================

  /// Analyze recipe and get nutritional information
  Future<NutritionData?> analyzeNutrition({
    required String recipeName,
    required List<String> ingredients,
    required List<String> quantities,
  }) async {
    if (!isConfigured()) {
      log('❌ Cannot analyze nutrition - API key not configured');
      return null;
    }

    try {
      log('🤖 AI: Analyzing nutrition for: $recipeName');
      log('   Ingredients: ${ingredients.length}');

      final prompt = AIPrompts.getNutritionPrompt(
        recipeName: recipeName,
        ingredients: ingredients,
        quantities: quantities,
      );

      final response = await _nutritionModel.generateContent([
        Content.text(prompt),
      ]);

      if (response.text == null || response.text!.isEmpty) {
        log('⚠️ AI: No response from Gemini');
        return null;
      }

      // Don't log full response - it might be truncated in console
      log('📊 AI Response received (length: ${response.text!.length} chars)');

      // Extract and parse JSON
      final jsonData = _extractAndParseJson(response.text!);
      
      if (jsonData == null) {
        log('❌ Failed to extract valid JSON from response');
        return null;
      }

      final nutritionData = NutritionData.fromJson(jsonData);
      
      log('✅ AI: Successfully parsed nutrition data');
      log('   Calories: ${nutritionData.caloriesPerServing}');
      log('   Health Score: ${nutritionData.healthScore}');

      return nutritionData;
    } catch (e, stackTrace) {
      log('❌ AI Error analyzing nutrition: $e');
      log('   Error type: ${e.runtimeType}');
      if (e is FormatException) {
        log('   Format error at: ${e.source}');
      }
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
    if (!isConfigured()) {
      log('❌ Cannot get health recommendations - API key not configured');
      return null;
    }

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

      if (response.text == null || response.text!.isEmpty) {
        log('⚠️ AI: No response from Gemini');
        return null;
      }

      log('🏥 AI Response received (length: ${response.text!.length} chars)');

      // Extract and parse JSON
      final jsonData = _extractAndParseJson(response.text!);
      
      if (jsonData == null) {
        log('❌ Failed to extract valid JSON from response');
        return null;
      }

      final recommendation = HealthRecommendation.fromJson(jsonData);
      
      log('✅ AI: Successfully parsed health recommendations');
      log('   Overall Rating: ${recommendation.overallRating}');
      log('   Suitable: ${recommendation.recommendations.suitable}');

      return recommendation;
    } catch (e, stackTrace) {
      log('❌ AI Error getting recommendations: $e');
      log('   Error type: ${e.runtimeType}');
      return null;
    }
  }

  // ==================== Helper Methods ====================

  /// Extract and parse JSON from response
  Map<String, dynamic>? _extractAndParseJson(String response) {
    try {
      // First, try direct JSON parsing (if responseMimeType worked)
      try {
        return jsonDecode(response) as Map<String, dynamic>;
      } catch (e) {
        // Continue to manual extraction
      }

      // Remove markdown code blocks
      String cleaned = response.trim();
      
      // Remove all variations of code blocks
      cleaned = cleaned.replaceAll(RegExp(r'```json\s*'), '');
      cleaned = cleaned.replaceAll(RegExp(r'```\s*'), '');
      cleaned = cleaned.replaceAll('```', '');
      cleaned = cleaned.trim();
      
      // Find JSON object boundaries
      final startIndex = cleaned.indexOf('{');
      final endIndex = cleaned.lastIndexOf('}');
      
      if (startIndex == -1 || endIndex == -1) {
        log('⚠️ No JSON object found in response');
        log('   Response starts with: ${cleaned.substring(0, cleaned.length > 50 ? 50 : cleaned.length)}');
        return null;
      }
      
      // Extract JSON
      cleaned = cleaned.substring(startIndex, endIndex + 1);
      
      // Validate balanced braces
      if (!_isValidJson(cleaned)) {
        log('⚠️ Invalid JSON structure detected');
        return null;
      }
      
      // Parse JSON
      return jsonDecode(cleaned) as Map<String, dynamic>;
      
    } catch (e) {
      log('❌ Error extracting/parsing JSON: $e');
      return null;
    }
  }

  /// Validate JSON structure
  bool _isValidJson(String json) {
    int braceCount = 0;
    int bracketCount = 0;
    
    for (int i = 0; i < json.length; i++) {
      switch (json[i]) {
        case '{':
          braceCount++;
          break;
        case '}':
          braceCount--;
          break;
        case '[':
          bracketCount++;
          break;
        case ']':
          bracketCount--;
          break;
      }
      
      // If counts go negative, invalid structure
      if (braceCount < 0 || bracketCount < 0) {
        return false;
      }
    }
    
    // All brackets must be balanced
    return braceCount == 0 && bracketCount == 0;
  }

  /// Check if API key is configured
  bool isConfigured() {
    return _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY_HERE';
  }

  /// Test API connection
  Future<bool> testConnection() async {
    if (!isConfigured()) {
      log('❌ Cannot test connection - API key not configured');
      return false;
    }

    try {
      log('🔍 Testing API connection...');
      final response = await _nutritionModel.generateContent([
        Content.text('Return only the word "OK"'),
      ]);
      
      final text = response.text?.trim() ?? '';
      final isOk = text.contains('OK');
      
      if (isOk) {
        log('✅ AI Connection test successful');
      } else {
        log('⚠️ AI Connection test failed - Response: $text');
      }
      
      return isOk;
    } catch (e) {
      log('❌ AI: Connection test failed: $e');
      return false;
    }
  }

  // ==================== Caching ====================

  final Map<String, NutritionData> _nutritionCache = {};
  final Map<String, HealthRecommendation> _healthCache = {};

  /// Get cached nutrition data
  NutritionData? getCachedNutrition(String recipeId) {
    final cached = _nutritionCache[recipeId];
    if (cached != null) {
      log('📦 Using cached nutrition data for: $recipeId');
    }
    return cached;
  }

  /// Cache nutrition data
  void cacheNutrition(String recipeId, NutritionData data) {
    _nutritionCache[recipeId] = data;
    log('💾 Cached nutrition data for: $recipeId');
  }

  /// Get cached health recommendation
  HealthRecommendation? getCachedHealth(String recipeId) {
    final cached = _healthCache[recipeId];
    if (cached != null) {
      log('📦 Using cached health data for: $recipeId');
    }
    return cached;
  }

  /// Cache health recommendation
  void cacheHealth(String recipeId, HealthRecommendation data) {
    _healthCache[recipeId] = data;
    log('💾 Cached health data for: $recipeId');
  }

  /// Clear all caches
  void clearCache() {
    final nutritionCount = _nutritionCache.length;
    final healthCount = _healthCache.length;
    
    _nutritionCache.clear();
    _healthCache.clear();
    
    log('🗑️ Cleared cache: $nutritionCount nutrition, $healthCount health');
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'nutrition': _nutritionCache.length,
      'health': _healthCache.length,
    };
  }
}