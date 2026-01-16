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
    debugPrint('🔐 AuthMiddleware: Checking route: $route');

    // IMPORTANT: Never block splash screen
    if (route == AppRoutes.splash) {
      debugPrint('✅ Splash screen - allowing access');
      return null;
    }

    try {
      final authService = Get.find<AuthService>();
      final isAuthenticated = authService.isAuthenticated;

      debugPrint('🔐 Is Authenticated: $isAuthenticated');

      // If trying to access AUTH page while LOGGED IN -> Redirect to HOME
      if (route == AppRoutes.auth && isAuthenticated) {
        debugPrint('✅ User is logged in, redirecting to home');
        return const RouteSettings(name: AppRoutes.home);
      }

      // Protected routes list
      final protectedRoutes = [
        AppRoutes.home,
        AppRoutes.allCategories,
        AppRoutes.category,
        AppRoutes.recipe,
        AppRoutes.profile,
        AppRoutes.editProfile,
        AppRoutes.allFavourites,
      ];

      // If trying to access PROTECTED pages while NOT logged in -> Redirect to AUTH
      if (protectedRoutes.contains(route) && !isAuthenticated) {
        debugPrint('❌ User not logged in, redirecting to auth');
        return const RouteSettings(name: AppRoutes.auth);
      }

      // Allow access
      debugPrint('✅ Access granted to: $route');
      return null;
    } catch (e) {
      debugPrint('⚠️ AuthMiddleware Error: $e');
      // If auth service not found and trying to access protected route
      if (route != AppRoutes.auth && route != AppRoutes.splash) {
        return const RouteSettings(name: AppRoutes.auth);
      }
      return null;
    }
  }


  /// Alternative: Use this for async storage checks
  /// This is useful if you need to check secure storage
  // Future<RouteSettings?> redirectAsync(String? route) async {
  //    if (route == AppRoutes.splash) {
  //     debugPrint('✅ Splash screen - allowing access');
  //     return null;
  //   }
  //   try {
  //     final authService = Get.find<AuthService>();
  //     final storageService = Get.find<SecureStorageService>();

  //     // Check both Firebase auth and stored login status
  //     final isAuthenticated = authService.isAuthenticated;
  //     final isLoggedInStorage = await storageService.isLoggedIn();

  //     debugPrint('🔐 AuthMiddleware Async: Route=$route');
  //     debugPrint('🔐 Firebase Auth: $isAuthenticated');
  //     debugPrint('🔐 Storage Auth: $isLoggedInStorage');

  //     // Use Firebase as source of truth, but storage as backup
  //     final shouldAllowAccess = isAuthenticated || isLoggedInStorage;

  //     // If accessing auth page while logged in
  //     if (route == AppRoutes.auth && shouldAllowAccess) {
  //       return const RouteSettings(name: AppRoutes.home);
  //     }

  //     // If accessing protected routes while not logged in
  //     final protectedRoutes = [
  //       AppRoutes.home,
  //       AppRoutes.category,
  //       AppRoutes.recipe,
  //     ];

  //     if (protectedRoutes.contains(route) && !shouldAllowAccess) {
  //       return const RouteSettings(name: AppRoutes.auth);
  //     }

  //     return null;
  //   } catch (e) {
  //     debugPrint('⚠️ AuthMiddleware Error: $e');
  //     // On error, redirect to auth for safety
  //     return const RouteSettings(name: AppRoutes.auth);
  //   }
  // }
}