// lib/models/ai_models.dart

/// Nutrition data model
class NutritionData {
  final String recipeName;
  final String servingSize;
  final NutritionInfo nutrition;
  final MacroBreakdown macroBreakdown;
  final int estimatedServings;
  final int caloriesPerServing;
  final int healthScore;
  final List<String> dietaryFlags;
  final List<String> allergens;
  final double confidence;

  NutritionData({
    required this.recipeName,
    required this.servingSize,
    required this.nutrition,
    required this.macroBreakdown,
    required this.estimatedServings,
    required this.caloriesPerServing,
    required this.healthScore,
    required this.dietaryFlags,
    required this.allergens,
    required this.confidence,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      recipeName: json['recipeName'] as String,
      servingSize: json['servingSize'] as String,
      nutrition: NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>),
      macroBreakdown: MacroBreakdown.fromJson(json['macroBreakdown'] as Map<String, dynamic>),
      estimatedServings: json['estimatedServings'] as int,
      caloriesPerServing: json['caloriesPerServing'] as int,
      healthScore: json['healthScore'] as int,
      dietaryFlags: List<String>.from(json['dietaryFlags'] as List),
      allergens: List<String>.from(json['allergens'] as List),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'servingSize': servingSize,
      'nutrition': nutrition.toJson(),
      'macroBreakdown': macroBreakdown.toJson(),
      'estimatedServings': estimatedServings,
      'caloriesPerServing': caloriesPerServing,
      'healthScore': healthScore,
      'dietaryFlags': dietaryFlags,
      'allergens': allergens,
      'confidence': confidence,
    };
  }
}

/// Nutrition information
class NutritionInfo {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double cholesterol;
  final double saturatedFat;
  final double transFat;
  final double vitaminA;
  final double vitaminC;
  final double calcium;
  final double iron;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.cholesterol,
    required this.saturatedFat,
    required this.transFat,
    required this.vitaminA,
    required this.vitaminC,
    required this.calcium,
    required this.iron,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      saturatedFat: (json['saturatedFat'] as num).toDouble(),
      transFat: (json['transFat'] as num).toDouble(),
      vitaminA: (json['vitaminA'] as num).toDouble(),
      vitaminC: (json['vitaminC'] as num).toDouble(),
      calcium: (json['calcium'] as num).toDouble(),
      iron: (json['iron'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'saturatedFat': saturatedFat,
      'transFat': transFat,
      'vitaminA': vitaminA,
      'vitaminC': vitaminC,
      'calcium': calcium,
      'iron': iron,
    };
  }
}

/// Macro breakdown percentages
class MacroBreakdown {
  final int proteinPercent;
  final int carbsPercent;
  final int fatPercent;

  MacroBreakdown({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  factory MacroBreakdown.fromJson(Map<String, dynamic> json) {
    return MacroBreakdown(
      proteinPercent: json['proteinPercent'] as int,
      carbsPercent: json['carbsPercent'] as int,
      fatPercent: json['fatPercent'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proteinPercent': proteinPercent,
      'carbsPercent': carbsPercent,
      'fatPercent': fatPercent,
    };
  }
}

/// Health recommendation data
class HealthRecommendation {
  final String recipeName;
  final String overallRating;
  final int healthScore;
  final Recommendations recommendations;
  final PersonalizedAdvice personalizedAdvice;
  final List<AlternativeRecipe> alternatives;
  final String nutritionistTip;
  final double confidence;

  HealthRecommendation({
    required this.recipeName,
    required this.overallRating,
    required this.healthScore,
    required this.recommendations,
    required this.personalizedAdvice,
    required this.alternatives,
    required this.nutritionistTip,
    required this.confidence,
  });

  factory HealthRecommendation.fromJson(Map<String, dynamic> json) {
    return HealthRecommendation(
      recipeName: json['recipeName'] as String,
      overallRating: json['overallRating'] as String,
      healthScore: json['healthScore'] as int,
      recommendations: Recommendations.fromJson(json['recommendations'] as Map<String, dynamic>),
      personalizedAdvice: PersonalizedAdvice.fromJson(json['personalizedAdvice'] as Map<String, dynamic>),
      alternatives: (json['alternatives'] as List)
          .map((e) => AlternativeRecipe.fromJson(e as Map<String, dynamic>))
          .toList(),
      nutritionistTip: json['nutritionistTip'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'overallRating': overallRating,
      'healthScore': healthScore,
      'recommendations': recommendations.toJson(),
      'personalizedAdvice': personalizedAdvice.toJson(),
      'alternatives': alternatives.map((e) => e.toJson()).toList(),
      'nutritionistTip': nutritionistTip,
      'confidence': confidence,
    };
  }
}

/// Recommendations details
class Recommendations {
  final bool suitable;
  final List<Concern> concerns;
  final List<Benefit> benefits;
  final List<Modification> modifications;

  Recommendations({
    required this.suitable,
    required this.concerns,
    required this.benefits,
    required this.modifications,
  });

  factory Recommendations.fromJson(Map<String, dynamic> json) {
    return Recommendations(
      suitable: json['suitable'] as bool,
      concerns: (json['concerns'] as List)
          .map((e) => Concern.fromJson(e as Map<String, dynamic>))
          .toList(),
      benefits: (json['benefits'] as List)
          .map((e) => Benefit.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifications: (json['modifications'] as List)
          .map((e) => Modification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suitable': suitable,
      'concerns': concerns.map((e) => e.toJson()).toList(),
      'benefits': benefits.map((e) => e.toJson()).toList(),
      'modifications': modifications.map((e) => e.toJson()).toList(),
    };
  }
}

/// Health concern
class Concern {
  final String type;
  final String title;
  final String description;
  final String severity;
  final String icon;

  Concern({
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
  });

  factory Concern.fromJson(Map<String, dynamic> json) {
    return Concern(
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'severity': severity,
      'icon': icon,
    };
  }
}

/// Health benefit
class Benefit {
  final String title;
  final String description;
  final String icon;

  Benefit({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}

/// Recipe modification suggestion
class Modification {
  final String title;
  final String original;
  final String replacement;
  final String reason;
  final String impact;

  Modification({
    required this.title,
    required this.original,
    required this.replacement,
    required this.reason,
    required this.impact,
  });

  factory Modification.fromJson(Map<String, dynamic> json) {
    return Modification(
      title: json['title'] as String,
      original: json['original'] as String,
      replacement: json['replacement'] as String,
      reason: json['reason'] as String,
      impact: json['impact'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'original': original,
      'replacement': replacement,
      'reason': reason,
      'impact': impact,
    };
  }
}

/// Personalized advice
class PersonalizedAdvice {
  final String forCondition;
  final bool canConsume;
  final String frequency;
  final String portionAdvice;
  final String bestTimeToEat;
  final List<String> pairingIdeas;

  PersonalizedAdvice({
    required this.forCondition,
    required this.canConsume,
    required this.frequency,
    required this.portionAdvice,
    required this.bestTimeToEat,
    required this.pairingIdeas,
  });

  factory PersonalizedAdvice.fromJson(Map<String, dynamic> json) {
    return PersonalizedAdvice(
      forCondition: json['forCondition'] as String,
      canConsume: json['canConsume'] as bool,
      frequency: json['frequency'] as String,
      portionAdvice: json['portionAdvice'] as String,
      bestTimeToEat: json['bestTimeToEat'] as String,
      pairingIdeas: List<String>.from(json['pairingIdeas'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forCondition': forCondition,
      'canConsume': canConsume,
      'frequency': frequency,
      'portionAdvice': portionAdvice,
      'bestTimeToEat': bestTimeToEat,
      'pairingIdeas': pairingIdeas,
    };
  }
}

/// Alternative recipe suggestion
class AlternativeRecipe {
  final String name;
  final String reason;
  final int calories;

  AlternativeRecipe({
    required this.name,
    required this.reason,
    required this.calories,
  });

  factory AlternativeRecipe.fromJson(Map<String, dynamic> json) {
    return AlternativeRecipe(
      name: json['name'] as String,
      reason: json['reason'] as String,
      calories: json['calories'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reason': reason,
      'calories': calories,
    };
  }
}