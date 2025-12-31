// lib/services/profile_services/profile_service.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:recipe_book/services/auth_services/auth_service.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';

import '../../models/user_profile_model.dart';


/// Service for managing user profiles
/// Stores profiles in secure local storage

class ProfileService extends GetxService {
  static ProfileService get instance => Get.find<ProfileService>();

  final _secureStorage = SecureStorageService.instance;
  final _authService = AuthService.instance;

  static const String _keyProfile = 'user_profile';

  // ==================== Create/Read Profile ====================

  /// Get current user's profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final profileJson = await _secureStorage.getUserData();
      if (profileJson == null) return null;

      // Try to get extended profile
      final extendedJson = await _secureStorage.read(key: _keyProfile);
      if (extendedJson != null) {
        final profileMap = jsonDecode(extendedJson) as Map<String, dynamic>;
        return UserProfile.fromJson(profileMap);
      }

      // Return basic profile from auth
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user profile: $e');
      return null;
    }
  }

  /// Create new profile for user
  Future<UserProfile?> createProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No authenticated user');
        return null;
      }

      final profile = UserProfile(
        userId: currentUser.uid,
        displayName: displayName ?? currentUser.displayName,
        email: email ?? currentUser.email,
        photoUrl: photoUrl ?? currentUser.photoUrl,
      );

      await saveProfile(profile);
      debugPrint('✅ Profile created for user: ${profile.userId}');
      return profile;
    } catch (e) {
      debugPrint('❌ Error creating profile: $e');
      return null;
    }
  }

  /// Save profile to storage
  Future<bool> saveProfile(UserProfile profile) async {
    try {
      final profileJson = jsonEncode(profile.toJson());
      await _secureStorage.write(key: _keyProfile, value: profileJson);
      debugPrint('✅ Profile saved successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving profile: $e');
      return false;
    }
  }

  /// Update profile
  Future<UserProfile?> updateProfile(UserProfile profile) async {
    try {
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      final success = await saveProfile(updatedProfile);
      return success ? updatedProfile : null;
    } catch (e) {
      debugPrint('❌ Error updating profile: $e');
      return null;
    }
  }

  /// Delete profile
  Future<bool> deleteProfile() async {
    try {
      await _secureStorage.delete(key: _keyProfile);
      debugPrint('✅ Profile deleted');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting profile: $e');
      return false;
    }
  }

  // ==================== Health Conditions ====================

  /// Add health condition
  Future<UserProfile?> addHealthCondition({
    required UserProfile profile,
    required String condition,
    String severity = 'moderate',
    String? notes,
  }) async {
    try {
      final newCondition = HealthCondition(
        name: condition,
        severity: severity,
        notes: notes,
      );

      final updatedConditions = [...profile.healthConditions, newCondition];
      final updatedProfile = profile.copyWith(
        healthConditions: updatedConditions,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error adding health condition: $e');
      return null;
    }
  }

  /// Remove health condition
  Future<UserProfile?> removeHealthCondition({
    required UserProfile profile,
    required String condition,
  }) async {
    try {
      final updatedConditions = profile.healthConditions
          .where((hc) => hc.name != condition)
          .toList();

      final updatedProfile = profile.copyWith(
        healthConditions: updatedConditions,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error removing health condition: $e');
      return null;
    }
  }

  /// Update health condition
  Future<UserProfile?> updateHealthCondition({
    required UserProfile profile,
    required HealthCondition oldCondition,
    required HealthCondition newCondition,
  }) async {
    try {
      final updatedConditions = profile.healthConditions.map((hc) {
        return hc.name == oldCondition.name ? newCondition : hc;
      }).toList();

      final updatedProfile = profile.copyWith(
        healthConditions: updatedConditions,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error updating health condition: $e');
      return null;
    }
  }

  // ==================== Allergies ====================

  /// Add allergy
  Future<UserProfile?> addAllergy({
    required UserProfile profile,
    required String allergy,
  }) async {
    try {
      if (profile.allergies.contains(allergy)) {
        debugPrint('⚠️ Allergy already exists');
        return profile;
      }

      final updatedAllergies = [...profile.allergies, allergy];
      final updatedProfile = profile.copyWith(allergies: updatedAllergies);

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error adding allergy: $e');
      return null;
    }
  }

  /// Remove allergy
  Future<UserProfile?> removeAllergy({
    required UserProfile profile,
    required String allergy,
  }) async {
    try {
      final updatedAllergies = profile.allergies
          .where((a) => a != allergy)
          .toList();

      final updatedProfile = profile.copyWith(allergies: updatedAllergies);

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error removing allergy: $e');
      return null;
    }
  }

  // ==================== Dietary Restrictions ====================

  /// Add dietary restriction
  Future<UserProfile?> addDietaryRestriction({
    required UserProfile profile,
    required String restriction,
  }) async {
    try {
      if (profile.dietaryRestrictions.contains(restriction)) {
        debugPrint('⚠️ Restriction already exists');
        return profile;
      }

      final updatedRestrictions = [...profile.dietaryRestrictions, restriction];
      final updatedProfile = profile.copyWith(
        dietaryRestrictions: updatedRestrictions,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error adding dietary restriction: $e');
      return null;
    }
  }

  /// Remove dietary restriction
  Future<UserProfile?> removeDietaryRestriction({
    required UserProfile profile,
    required String restriction,
  }) async {
    try {
      final updatedRestrictions = profile.dietaryRestrictions
          .where((r) => r != restriction)
          .toList();

      final updatedProfile = profile.copyWith(
        dietaryRestrictions: updatedRestrictions,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error removing dietary restriction: $e');
      return null;
    }
  }

  // ==================== Personal Info ====================

  /// Update personal information
  Future<UserProfile?> updatePersonalInfo({
    required UserProfile profile,
    String? displayName,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
  }) async {
    try {
      final updatedProfile = profile.copyWith(
        displayName: displayName,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        activityLevel: activityLevel,
        goal: goal,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error updating personal info: $e');
      return null;
    }
  }

  // ==================== Preferences ====================

  /// Update cuisine preferences
  Future<UserProfile?> updateCuisinePreferences({
    required UserProfile profile,
    required List<String> preferences,
  }) async {
    try {
      final updatedProfile = profile.copyWith(
        cuisinePreferences: preferences,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error updating cuisine preferences: $e');
      return null;
    }
  }

  /// Update disliked ingredients
  Future<UserProfile?> updateDislikedIngredients({
    required UserProfile profile,
    required List<String> ingredients,
  }) async {
    try {
      final updatedProfile = profile.copyWith(
        dislikedIngredients: ingredients,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error updating disliked ingredients: $e');
      return null;
    }
  }

  // ==================== App Settings ====================

  /// Toggle AI recommendations
  Future<UserProfile?> toggleAIRecommendations({
    required UserProfile profile,
    required bool enabled,
  }) async {
    try {
      final updatedProfile = profile.copyWith(
        enableAIRecommendations: enabled,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error toggling AI recommendations: $e');
      return null;
    }
  }

  /// Toggle notifications
  Future<UserProfile?> toggleNotifications({
    required UserProfile profile,
    required bool enabled,
  }) async {
    try {
      final updatedProfile = profile.copyWith(
        enableNotifications: enabled,
      );

      return await updateProfile(updatedProfile);
    } catch (e) {
      debugPrint('❌ Error toggling notifications: $e');
      return null;
    }
  }

  // ==================== Utility Methods ====================

  /// Check if profile exists
  Future<bool> profileExists() async {
    try {
      final profile = await getUserProfile();
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  /// Get profile completion percentage
  int getProfileCompletionPercentage(UserProfile profile) {
    int completed = 0;
    const int total = 10;

    if (profile.displayName != null && profile.displayName!.isNotEmpty) completed++;
    if (profile.age != null) completed++;
    if (profile.gender != null) completed++;
    if (profile.height != null && profile.weight != null) completed++;
    if (profile.healthConditions.isNotEmpty) completed++;
    if (profile.allergies.isNotEmpty || profile.dietaryRestrictions.isNotEmpty) completed++;
    if (profile.activityLevel != null) completed++;
    if (profile.goal != null) completed++;
    if (profile.cuisinePreferences.isNotEmpty) completed++;
    if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty) completed++;

    return ((completed / total) * 100).round();
  }
}