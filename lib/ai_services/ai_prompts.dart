// lib/services/ai_services/ai_prompts.dart

class AIPrompts {
  AIPrompts._();

  /// System role for nutrition analysis
  static const String nutritionSystemRole = '''
You are a professional nutritionist and food scientist with expertise in analyzing recipes and calculating nutritional content. Your responses must be accurate, scientifically-backed, and formatted in valid JSON only.
''';

  /// Prompt for calorie and nutrition estimation
  static String getNutritionPrompt({
    required String recipeName,
    required List<String> ingredients,
    required List<String> quantities,
  }) {
    final ingredientsList = List.generate(
      ingredients.length,
      (i) => '${i + 1}. ${ingredients[i]}: ${quantities[i]}',
    ).join('\n');

    return '''
Analyze the following recipe and provide detailed nutritional information:

Recipe Name: $recipeName

Ingredients:
$ingredientsList

Calculate and return the nutritional information per serving in this EXACT JSON format (no markdown, no extra text):

{
  "recipeName": "$recipeName",
  "servingSize": "1 serving",
  "nutrition": {
    "calories": 450,
    "protein": 25.5,
    "carbohydrates": 52.0,
    "fat": 15.5,
    "fiber": 8.0,
    "sugar": 12.0,
    "sodium": 450,
    "cholesterol": 75,
    "saturatedFat": 5.5,
    "transFat": 0.0,
    "vitaminA": 15,
    "vitaminC": 25,
    "calcium": 20,
    "iron": 18
  },
  "macroBreakdown": {
    "proteinPercent": 22,
    "carbsPercent": 46,
    "fatPercent": 32
  },
  "estimatedServings": 4,
  "caloriesPerServing": 450,
  "healthScore": 75,
  "dietaryFlags": ["high-protein", "moderate-carb"],
  "allergens": ["dairy", "gluten"],
  "confidence": 0.85
}

Important:
- All numerical values should be realistic and accurate
- Use standard serving sizes
- Include only relevant allergens
- healthScore: 0-100 (higher is healthier)
- confidence: 0.0-1.0 (estimation accuracy)
- Return ONLY the JSON, no additional text
''';
  }

  /// System role for health recommendations
  static const String healthSystemRole = '''
You are a certified nutritionist and health advisor specializing in dietary recommendations for various health conditions. Provide evidence-based, actionable advice while being supportive and non-judgmental.
''';

  /// Prompt for health-based recommendations
  static String getHealthRecommendationPrompt({
    required String recipeName,
    required Map<String, dynamic> nutritionData,
    String? userHealthCondition,
    List<String>? dietaryRestrictions,
    List<String>? allergies,
  }) {
    final healthInfo = userHealthCondition != null
        ? 'User Health Condition: $userHealthCondition'
        : 'User has no specific health conditions';

    final dietInfo = dietaryRestrictions != null && dietaryRestrictions.isNotEmpty
        ? 'Dietary Restrictions: ${dietaryRestrictions.join(", ")}'
        : 'No dietary restrictions';

    final allergyInfo = allergies != null && allergies.isNotEmpty
        ? 'Allergies: ${allergies.join(", ")}'
        : 'No known allergies';

    return '''
Analyze this recipe and provide personalized health recommendations:

Recipe: $recipeName
$healthInfo
$dietInfo
$allergyInfo

Nutritional Data:
${_formatNutritionData(nutritionData)}

Provide comprehensive health analysis in this EXACT JSON format (no markdown):

{
  "recipeName": "$recipeName",
  "overallRating": "healthy",
  "healthScore": 75,
  "recommendations": {
    "suitable": true,
    "concerns": [
      {
        "type": "warning",
        "title": "High Sodium Content",
        "description": "This recipe contains 450mg sodium, which is 20% of daily limit",
        "severity": "moderate",
        "icon": "warning"
      }
    ],
    "benefits": [
      {
        "title": "High Protein",
        "description": "Excellent source of protein for muscle building and repair",
        "icon": "fitness_center"
      }
    ],
    "modifications": [
      {
        "title": "Reduce Sodium",
        "original": "1 tsp salt",
        "replacement": "1/2 tsp salt + herbs",
        "reason": "Lower sodium for heart health",
        "impact": "Reduces sodium by 50%"
      }
    ]
  },
  "personalizedAdvice": {
    "forCondition": "General Health",
    "canConsume": true,
    "frequency": "2-3 times per week",
    "portionAdvice": "Standard serving size is appropriate",
    "bestTimeToEat": "Lunch or dinner",
    "pairingIdeas": ["leafy green salad", "steamed vegetables"]
  },
  "alternatives": [
    {
      "name": "Grilled Chicken Salad",
      "reason": "Lower calorie option with similar protein",
      "calories": 320
    }
  ],
  "nutritionistTip": "This is a well-balanced meal. Consider adding more vegetables to increase fiber content.",
  "confidence": 0.88
}

Rating values: "very-healthy", "healthy", "moderate", "caution", "avoid"
Severity values: "low", "moderate", "high", "critical"
Return ONLY valid JSON, no markdown or extra text.
''';
  }

  /// Format nutrition data for prompt
  static String _formatNutritionData(Map<String, dynamic> data) {
    final nutrition = data['nutrition'] as Map<String, dynamic>?;
    if (nutrition == null) return 'No nutrition data available';

    return '''
Calories: ${nutrition['calories']} kcal
Protein: ${nutrition['protein']}g
Carbohydrates: ${nutrition['carbohydrates']}g
Fat: ${nutrition['fat']}g
Fiber: ${nutrition['fiber']}g
Sugar: ${nutrition['sugar']}g
Sodium: ${nutrition['sodium']}mg
''';
  }

  /// Prompt for recipe alternative suggestions
  static String getAlternativesPrompt({
    required String recipeName,
    required String healthCondition,
  }) {
    return '''
Suggest 3 healthier alternative recipes similar to "$recipeName" that are suitable for someone with $healthCondition.

Return in this EXACT JSON format:

{
  "alternatives": [
    {
      "name": "Alternative Recipe Name",
      "calories": 350,
      "reason": "Why this is better",
      "keyBenefits": ["benefit1", "benefit2"],
      "difficulty": "easy"
    }
  ]
}

Return ONLY valid JSON.
''';
  }

  /// Prompt for ingredient substitution
  static String getSubstitutionPrompt({
    required String ingredient,
    required String reason,
  }) {
    return '''
Suggest 3 healthy substitutions for "$ingredient" with reason: $reason

Return in this EXACT JSON format:

{
  "substitutions": [
    {
      "original": "$ingredient",
      "replacement": "Substitute name",
      "ratio": "1:1",
      "benefit": "Why this is better",
      "impact": "Nutritional impact"
    }
  ]
}

Return ONLY valid JSON.
''';
  }
}