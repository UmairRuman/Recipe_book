// lib/navigation/auth_middleware.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/services/auth_services/auth_service.dart';
import 'package:recipe_book/services/auth_services/secure_storage_service.dart';

/// Middleware to handle authentication checks for protected routes
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1; // Higher priority = runs first

  @override
  RouteSettings? redirect(String? route) {
    // Get auth service and storage service
    final authService = Get.find<AuthService>();
    final storageService = Get.find<SecureStorageService>();

    // Sync check using FirebaseAuth current user
    final isAuthenticated = authService.isAuthenticated;

    debugPrint('🔐 AuthMiddleware: Checking route: $route');
    debugPrint('🔐 Is Authenticated: $isAuthenticated');

    // ==================== Logic for Different Routes ====================

    // 1. If trying to access AUTH page while LOGGED IN -> Redirect to HOME
    if (route == AppRoutes.auth && isAuthenticated) {
      debugPrint('✅ User is logged in, redirecting to home');
      return const RouteSettings(name: AppRoutes.home);
    }

    // 2. If trying to access PROTECTED pages while NOT logged in -> Redirect to AUTH
    final protectedRoutes = [
      AppRoutes.home,
      AppRoutes.category,
      AppRoutes.recipe,
    ];

    if (protectedRoutes.contains(route) && !isAuthenticated) {
      debugPrint('❌ User not logged in, redirecting to auth');
      return const RouteSettings(name: AppRoutes.auth);
    }

    // 3. Allow access to the requested route
    debugPrint('✅ Access granted to: $route');
    return null; // null means proceed with the route
  }

  /// Alternative: Use this for async storage checks
  /// This is useful if you need to check secure storage
  Future<RouteSettings?> redirectAsync(String? route) async {
    try {
      final authService = Get.find<AuthService>();
      final storageService = Get.find<SecureStorageService>();

      // Check both Firebase auth and stored login status
      final isAuthenticated = authService.isAuthenticated;
      final isLoggedInStorage = await storageService.isLoggedIn();

      debugPrint('🔐 AuthMiddleware Async: Route=$route');
      debugPrint('🔐 Firebase Auth: $isAuthenticated');
      debugPrint('🔐 Storage Auth: $isLoggedInStorage');

      // Use Firebase as source of truth, but storage as backup
      final shouldAllowAccess = isAuthenticated || isLoggedInStorage;

      // If accessing auth page while logged in
      if (route == AppRoutes.auth && shouldAllowAccess) {
        return const RouteSettings(name: AppRoutes.home);
      }

      // If accessing protected routes while not logged in
      final protectedRoutes = [
        AppRoutes.home,
        AppRoutes.category,
        AppRoutes.recipe,
      ];

      if (protectedRoutes.contains(route) && !shouldAllowAccess) {
        return const RouteSettings(name: AppRoutes.auth);
      }

      return null;
    } catch (e) {
      debugPrint('⚠️ AuthMiddleware Error: $e');
      // On error, redirect to auth for safety
      return const RouteSettings(name: AppRoutes.auth);
    }
  }
}