// lib/models/user_profile_model.dart

/// Complete user profile with health and dietary information
class UserProfile {
  final String userId;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  
  // Personal Info
  final int? age;
  final String? gender; // 'male', 'female', 'other', 'prefer-not-to-say'
  final double? height; // in cm
  final double? weight; // in kg
  
  // Health Information
  final List<HealthCondition> healthConditions;
  final List<String> allergies;
  final List<String> dietaryRestrictions;
  
  // Preferences
  final String? activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very-active'
  final String? goal; // 'lose-weight', 'maintain', 'gain-weight', 'muscle-gain', 'general-health'
  final List<String> cuisinePreferences;
  final List<String> dislikedIngredients;
  
  // App Settings
  final bool enableAIRecommendations;
  final bool enableNotifications;
  final bool shareHealthData;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.userId,
    this.displayName,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.healthConditions = const [],
    this.allergies = const [],
    this.dietaryRestrictions = const [],
    this.activityLevel,
    this.goal,
    this.cuisinePreferences = const [],
    this.dislikedIngredients = const [],
    this.enableAIRecommendations = true,
    this.enableNotifications = true,
    this.shareHealthData = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Calculate BMI if height and weight are available
  double? get bmi {
    if (height == null || weight == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Calculate daily calorie needs (Harris-Benedict Equation)
  double? get dailyCalorieNeeds {
    if (age == null || weight == null || height == null || gender == null) {
      return null;
    }

    // BMR calculation
    double bmr;
    if (gender == 'male') {
      bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
    } else {
      bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
    }

    // Activity multiplier
    final multipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very-active': 1.9,
    };

    final multiplier = multipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Check if user has specific health condition
  bool hasHealthCondition(String condition) {
    return healthConditions.any((hc) => hc.name.toLowerCase() == condition.toLowerCase());
  }

  /// Check if user is allergic to ingredient
  bool isAllergicTo(String ingredient) {
    return allergies.any((allergy) => 
      ingredient.toLowerCase().contains(allergy.toLowerCase())
    );
  }

  /// Check if recipe matches dietary restrictions
  bool matchesDietaryRestrictions(List<String> recipeFlags) {
    // If user has no restrictions, all recipes are suitable
    if (dietaryRestrictions.isEmpty) return true;
    
    // Check if recipe has all required flags
    for (var restriction in dietaryRestrictions) {
      if (!recipeFlags.contains(restriction)) return false;
    }
    return true;
  }

  /// Convert to JSON for Firestore/API
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'healthConditions': healthConditions.map((hc) => hc.toJson()).toList(),
      'allergies': allergies,
      'dietaryRestrictions': dietaryRestrictions,
      'activityLevel': activityLevel,
      'goal': goal,
      'cuisinePreferences': cuisinePreferences,
      'dislikedIngredients': dislikedIngredients,
      'enableAIRecommendations': enableAIRecommendations,
      'enableNotifications': enableNotifications,
      'shareHealthData': shareHealthData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON (Firestore/API)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      healthConditions: (json['healthConditions'] as List?)
              ?.map((hc) => HealthCondition.fromJson(hc as Map<String, dynamic>))
              .toList() ??
          [],
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] as List? ?? []),
      activityLevel: json['activityLevel'] as String?,
      goal: json['goal'] as String?,
      cuisinePreferences: List<String>.from(json['cuisinePreferences'] as List? ?? []),
      dislikedIngredients: List<String>.from(json['dislikedIngredients'] as List? ?? []),
      enableAIRecommendations: json['enableAIRecommendations'] as bool? ?? true,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      shareHealthData: json['shareHealthData'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Create empty profile for new user
  factory UserProfile.empty(String userId) {
    return UserProfile(
      userId: userId,
      healthConditions: [],
      allergies: [],
      dietaryRestrictions: [],
    );
  }

  /// Copy with updated fields
  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    int? age,
    String? gender,
    double? height,
    double? weight,
    List<HealthCondition>? healthConditions,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    String? activityLevel,
    String? goal,
    List<String>? cuisinePreferences,
    List<String>? dislikedIngredients,
    bool? enableAIRecommendations,
    bool? enableNotifications,
    bool? shareHealthData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      healthConditions: healthConditions ?? this.healthConditions,
      allergies: allergies ?? this.allergies,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      enableAIRecommendations: enableAIRecommendations ?? this.enableAIRecommendations,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      shareHealthData: shareHealthData ?? this.shareHealthData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // lib/models/user_profile_model.dart

/// Calculate profile completion percentage
int get completionPercentage {
  int totalFields = 15;
  int completedFields = 0;

  // Basic Info (4)
  if (displayName?.trim().isNotEmpty ?? false) completedFields++;
  if (email?.trim().isNotEmpty ?? false) completedFields++;
  if (age != null && age! > 0) completedFields++;
  if (gender?.isNotEmpty ?? false) completedFields++;

  // Physical (2)
  if (height != null && height! > 0) completedFields++;
  if (weight != null && weight! > 0) completedFields++;

  // Health & Lifestyle (3)
  if (activityLevel?.isNotEmpty ?? false) completedFields++;
  if (goal?.isNotEmpty ?? false) completedFields++;
  if (healthConditions.isNotEmpty) completedFields++;

  // Dietary (3)
  if (allergies.isNotEmpty) completedFields++;
  if (dietaryRestrictions.isNotEmpty) completedFields++;
  if (cuisinePreferences.isNotEmpty) completedFields++;

  // Preferences (3)
  if (dislikedIngredients.isNotEmpty) completedFields++;
  completedFields++; // enableAIRecommendations
  completedFields++; // enableNotifications

  return ((completedFields / totalFields) * 100).round();
}

  @override
  String toString() {
    return 'UserProfile(userId: $userId, displayName: $displayName, conditions: ${healthConditions.length})';
  }
}

/// Health condition with severity and notes
class HealthCondition {
  final String name;
  final String severity; // 'mild', 'moderate', 'severe'
  final String? notes;
  final DateTime diagnosedDate;
  final bool isActive;

  HealthCondition({
    required this.name,
    this.severity = 'moderate',
    this.notes,
    DateTime? diagnosedDate,
    this.isActive = true,
  }) : diagnosedDate = diagnosedDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'severity': severity,
      'notes': notes,
      'diagnosedDate': diagnosedDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory HealthCondition.fromJson(Map<String, dynamic> json) {
    return HealthCondition(
      name: json['name'] as String,
      severity: json['severity'] as String? ?? 'moderate',
      notes: json['notes'] as String?,
      diagnosedDate: json['diagnosedDate'] != null
          ? DateTime.parse(json['diagnosedDate'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  HealthCondition copyWith({
    String? name,
    String? severity,
    String? notes,
    DateTime? diagnosedDate,
    bool? isActive,
  }) {
    return HealthCondition(
      name: name ?? this.name,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Common health conditions
class CommonHealthConditions {
  static const List<String> conditions = [
    'Diabetes Type 1',
    'Diabetes Type 2',
    'High Blood Pressure',
    'High Cholesterol',
    'Heart Disease',
    'Kidney Disease',
    'Liver Disease',
    'Celiac Disease',
    'IBS (Irritable Bowel Syndrome)',
    'GERD (Acid Reflux)',
    'Lactose Intolerance',
    'Gluten Sensitivity',
    'Food Allergies',
    'Obesity',
    'Underweight',
    'Anemia',
    'Thyroid Disorder',
    'PCOS',
    'Pregnancy',
    'Breastfeeding',
  ];
}

/// Common dietary restrictions
class CommonDietaryRestrictions {
  static const List<String> restrictions = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Keto',
    'Paleo',
    'Low-Carb',
    'Low-Fat',
    'Low-Sodium',
    'Low-Sugar',
    'Gluten-Free',
    'Dairy-Free',
    'Nut-Free',
    'Halal',
    'Kosher',
    'Organic',
    'Whole30',
    'Mediterranean',
    'DASH Diet',
    'Intermittent Fasting',
  ];
}

/// Common allergens
class CommonAllergens {
  static const List<String> allergens = [
    'Peanuts',
    'Tree Nuts',
    'Milk/Dairy',
    'Eggs',
    'Soy',
    'Wheat/Gluten',
    'Fish',
    'Shellfish',
    'Sesame',
    'Mustard',
    'Celery',
    'Lupin',
    'Sulfites',
    'Mollusks',
  ];
}