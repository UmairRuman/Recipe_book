// lib/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/profile_services/profile_service.dart';
import '../models/user_profile_model.dart';
import '../services/auth_services/auth_service.dart';

/// Controller for managing user profile state and operations
class ProfileController extends GetxController {
  static ProfileController get instance => Get.find<ProfileController>();

  final _profileService = ProfileService.instance;
  final _authService = AuthService.instance;

  // ==================== Reactive State ====================

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final isLoading = false.obs;
  final isEditing = false.obs;
  final profileCompletion = 0.obs;

  // Form controllers for editing
  final displayNameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
   debugPrint('📋 ProfileController initialized');
  }


// Add this method to be called when ProfilePage is opened
@override
void onReady() {
  super.onReady();
  // Only load if user is authenticated and profile not loaded yet
  if (_authService.isAuthenticated && userProfile.value == null) {
    loadProfile();
  }
}
  @override
  void onClose() {
    displayNameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }

  // ==================== Profile Loading ====================

  /// Load user profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final profile = await _profileService.getUserProfile();

      if (profile != null) {
        userProfile.value = profile;
        _updateFormControllers(profile);
        _calculateCompletion();
        debugPrint('✅ Profile loaded: ${profile.displayName}');
      } else {
        // Create new profile for authenticated user
        final authUser = _authService.currentUser;
        if (authUser != null) {
          debugPrint('📝 Creating new profile for user');
          await createInitialProfile();
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading profile: $e');
      _showError('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create initial profile for new user
  Future<void> createInitialProfile() async {
    try {
      final profile = await _profileService.createProfile(
        displayName: _authService.currentUser?.displayName,
        email: _authService.currentUser?.email,
        photoUrl: _authService.currentUser?.photoUrl,
      );

      if (profile != null) {
        userProfile.value = profile;
        _updateFormControllers(profile);
        _calculateCompletion();
        _showSuccess('Profile created successfully');
      }
    } catch (e) {
      debugPrint('❌ Error creating initial profile: $e');
    }
  }

  /// Reload profile
  Future<void> reloadProfile() async {
    await loadProfile();
  }

  // ==================== Personal Info Management ====================

  /// Update personal information
  Future<void> updatePersonalInfo({
    String? displayName,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
  }) async {
    try {
      if (userProfile.value == null) return;

      isLoading.value = true;

      final updatedProfile = await _profileService.updatePersonalInfo(
        profile: userProfile.value!,
        displayName: displayName,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        activityLevel: activityLevel,
        goal: goal,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _updateFormControllers(updatedProfile);
        _calculateCompletion();
        _showSuccess('Personal information updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating personal info: $e');
      _showError('Failed to update information');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Health Conditions Management ====================

  /// Add health condition
  Future<void> addHealthCondition({
    required String condition,
    String severity = 'moderate',
    String? notes,
  }) async {
    try {
      if (userProfile.value == null) return;

      isLoading.value = true;

      final updatedProfile = await _profileService.addHealthCondition(
        profile: userProfile.value!,
        condition: condition,
        severity: severity,
        notes: notes,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Health condition added');
      }
    } catch (e) {
      debugPrint('❌ Error adding health condition: $e');
      _showError('Failed to add health condition');
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove health condition
  Future<void> removeHealthCondition(String condition) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.removeHealthCondition(
        profile: userProfile.value!,
        condition: condition,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Health condition removed');
      }
    } catch (e) {
      debugPrint('❌ Error removing health condition: $e');
      _showError('Failed to remove health condition');
    }
  }

  /// Update health condition
  Future<void> updateHealthCondition({
    required HealthCondition oldCondition,
    required HealthCondition newCondition,
  }) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.updateHealthCondition(
        profile: userProfile.value!,
        oldCondition: oldCondition,
        newCondition: newCondition,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _showSuccess('Health condition updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating health condition: $e');
      _showError('Failed to update health condition');
    }
  }

  // ==================== Allergies Management ====================

  /// Add allergy
  Future<void> addAllergy(String allergy) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.addAllergy(
        profile: userProfile.value!,
        allergy: allergy,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Allergy added');
      }
    } catch (e) {
      debugPrint('❌ Error adding allergy: $e');
      _showError('Failed to add allergy');
    }
  }

  /// Remove allergy
  Future<void> removeAllergy(String allergy) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.removeAllergy(
        profile: userProfile.value!,
        allergy: allergy,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Allergy removed');
      }
    } catch (e) {
      debugPrint('❌ Error removing allergy: $e');
      _showError('Failed to remove allergy');
    }
  }

  // ==================== Dietary Restrictions Management ====================

  /// Add dietary restriction
  Future<void> addDietaryRestriction(String restriction) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.addDietaryRestriction(
        profile: userProfile.value!,
        restriction: restriction,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Dietary restriction added');
      }
    } catch (e) {
      debugPrint('❌ Error adding dietary restriction: $e');
      _showError('Failed to add dietary restriction');
    }
  }

  /// Remove dietary restriction
  Future<void> removeDietaryRestriction(String restriction) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.removeDietaryRestriction(
        profile: userProfile.value!,
        restriction: restriction,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Dietary restriction removed');
      }
    } catch (e) {
      debugPrint('❌ Error removing dietary restriction: $e');
      _showError('Failed to remove dietary restriction');
    }
  }

  // ==================== Preferences Management ====================

  /// Update cuisine preferences
  Future<void> updateCuisinePreferences(List<String> preferences) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.updateCuisinePreferences(
        profile: userProfile.value!,
        preferences: preferences,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _calculateCompletion();
        _showSuccess('Cuisine preferences updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating cuisine preferences: $e');
      _showError('Failed to update preferences');
    }
  }

  /// Update disliked ingredients
  Future<void> updateDislikedIngredients(List<String> ingredients) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.updateDislikedIngredients(
        profile: userProfile.value!,
        ingredients: ingredients,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _showSuccess('Disliked ingredients updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating disliked ingredients: $e');
      _showError('Failed to update ingredients');
    }
  }

  // ==================== Settings Management ====================

  /// Toggle AI recommendations
  Future<void> toggleAIRecommendations(bool enabled) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.toggleAIRecommendations(
        profile: userProfile.value!,
        enabled: enabled,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _showSuccess(
          enabled 
              ? 'AI recommendations enabled' 
              : 'AI recommendations disabled'
        );
      }
    } catch (e) {
      debugPrint('❌ Error toggling AI recommendations: $e');
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    try {
      if (userProfile.value == null) return;

      final updatedProfile = await _profileService.toggleNotifications(
        profile: userProfile.value!,
        enabled: enabled,
      );

      if (updatedProfile != null) {
        userProfile.value = updatedProfile;
        _showSuccess(
          enabled ? 'Notifications enabled' : 'Notifications disabled'
        );
      }
    } catch (e) {
      debugPrint('❌ Error toggling notifications: $e');
    }
  }

  // ==================== Helper Methods ====================

  /// Update form controllers from profile
  void _updateFormControllers(UserProfile profile) {
    displayNameController.text = profile.displayName ?? '';
    ageController.text = profile.age?.toString() ?? '';
    heightController.text = profile.height?.toString() ?? '';
    weightController.text = profile.weight?.toString() ?? '';
  }

  /// Calculate profile completion percentage
  void _calculateCompletion() {
  if (userProfile.value == null) {
    profileCompletion.value = 0;
    return;
  }

  final completion = _profileService.getProfileCompletionPercentage(
    userProfile.value!,
  );
  
  profileCompletion.value = completion;
  debugPrint('🎯 Profile completion updated: $completion%');
}

  /// Show success message
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // ==================== Getters ====================

  /// Check if profile is complete enough for AI recommendations
  bool get isProfileCompleteForAI {
    if (userProfile.value == null) return false;
    return profileCompletion.value >= 50;
  }

  /// Get health summary
  String get healthSummary {
    if (userProfile.value == null) return 'No health information';
    
    final conditions = userProfile.value!.healthConditions.length;
    final allergies = userProfile.value!.allergies.length;
    final restrictions = userProfile.value!.dietaryRestrictions.length;
    
    return '$conditions conditions, $allergies allergies, $restrictions restrictions';
  }

  /// Check if user has critical health conditions
  bool get hasCriticalConditions {
    if (userProfile.value == null) return false;
    
    return userProfile.value!.healthConditions.any(
      (condition) => condition.severity == 'severe',
    );
  }
}