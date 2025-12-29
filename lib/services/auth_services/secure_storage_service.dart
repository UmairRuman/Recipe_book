// lib/services/auth_services/secure_storage_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:recipe_book/model/user_model.dart';


/// Service for securely storing and retrieving user credentials and data
/// Uses flutter_secure_storage for encrypted storage on device
class SecureStorageService extends GetxService {
  static SecureStorageService get instance => Get.find<SecureStorageService>();

  late final FlutterSecureStorage _secureStorage;

  // Storage Keys
  static const String _keyUser = 'user_data';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'saved_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyAuthToken = 'auth_token';

  @override
  void onInit() {
    super.onInit();
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // ==================== User Data Operations ====================

  /// Save user data securely
  Future<void> saveUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(key: _keyUser, value: userJson);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get saved user data
  Future<UserModel?> getUserData() async {
    try {
      final userJson = await _secureStorage.read(key: _keyUser);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  /// Delete user data
  Future<void> deleteUserData() async {
    try {
      await _secureStorage.delete(key: _keyUser);
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  // ==================== Remember Me Operations ====================

  /// Save "Remember Me" preference and email
  Future<void> saveRememberMe({
    required bool rememberMe,
    required String email,
  }) async {
    try {
      await _secureStorage.write(
        key: _keyRememberMe,
        value: rememberMe.toString(),
      );
      
      if (rememberMe) {
        await _secureStorage.write(key: _keyEmail, value: email);
      } else {
        await _secureStorage.delete(key: _keyEmail);
      }
    } catch (e) {
      throw Exception('Failed to save remember me preference: $e');
    }
  }

  /// Get "Remember Me" preference
  Future<bool> getRememberMe() async {
    try {
      final value = await _secureStorage.read(key: _keyRememberMe);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Get saved email if "Remember Me" is enabled
  Future<String?> getSavedEmail() async {
    try {
      final rememberMe = await getRememberMe();
      if (!rememberMe) return null;
      
      return await _secureStorage.read(key: _keyEmail);
    } catch (e) {
      return null;
    }
  }

  // ==================== Login Status Operations ====================

  /// Set login status
  Future<void> setLoginStatus(bool isLoggedIn) async {
    try {
      await _secureStorage.write(
        key: _keyIsLoggedIn,
        value: isLoggedIn.toString(),
      );
    } catch (e) {
      throw Exception('Failed to set login status: $e');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final value = await _secureStorage.read(key: _keyIsLoggedIn);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  // ==================== Auth Token Operations ====================

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _keyAuthToken, value: token);
    } catch (e) {
      throw Exception('Failed to save auth token: $e');
    }
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _keyAuthToken);
    } catch (e) {
      return null;
    }
  }

  /// Delete authentication token
  Future<void> deleteAuthToken() async {
    try {
      await _secureStorage.delete(key: _keyAuthToken);
    } catch (e) {
      throw Exception('Failed to delete auth token: $e');
    }
  }

  // ==================== Clear All Data ====================

  /// Clear all stored data (used during logout)
  Future<void> clearAll() async {
    try {
      await _secureStorage.delete(key: _keyUser);
      await _secureStorage.delete(key: _keyIsLoggedIn);
      await _secureStorage.delete(key: _keyAuthToken);
      // Keep remember me and email if user wants to be remembered
    } catch (e) {
      throw Exception('Failed to clear storage: $e');
    }
  }

  /// Clear absolutely everything including remember me
  Future<void> clearAllIncludingRememberMe() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear all storage: $e');
    }
  }

  // ==================== Utility Methods ====================

  /// Check if secure storage is available
  Future<bool> isStorageAvailable() async {
    try {
      await _secureStorage.write(key: 'test', value: 'test');
      await _secureStorage.delete(key: 'test');
      return true;
    } catch (e) {
      return false;
    }
  }
}