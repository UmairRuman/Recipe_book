// lib/utils/dependency_injection.dart

import 'package:get/get.dart';
import 'package:recipe_book/ai_services/gemini_ai_service.dart';
import 'package:recipe_book/controllers/ai_controller.dart';
import 'package:recipe_book/controllers/profile_controller.dart';
import 'package:recipe_book/pages/all_categories_page/controller/all_categories_controller.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';
import 'package:recipe_book/profile_services/profile_service.dart';
import '../services/auth_services/auth_service.dart';
import '../services/auth_services/secure_storage_service.dart';
import '../controllers/auth_controller.dart';

/// Initialize all dependencies at app startup
class DependencyInjection {
  static Future<void> init() async {
    // ==================== Initialize Services First ====================
    // Services must be initialized before controllers that depend on them
    
    // Initialize Secure Storage Service (for credential caching)
    await Get.putAsync(
      () async {
        final service = SecureStorageService();
        return service;
      },
      permanent: true, // Keep in memory throughout app lifecycle
    );

    // Initialize Auth Service (depends on SecureStorageService)
    await Get.putAsync(
      () async {
        final service = AuthService();
        return service;
      },
      permanent: true,
    );

    // Initialize Profile Service (before ProfileController)
    await Get.putAsync(
      () async {
        final service = ProfileService();
        return service;
      },
      permanent: true,
    );

    // Initialize Gemini AI Service (before AIController)
    Get.put(GeminiAIService(), permanent: true);

    // ==================== Initialize Controllers ====================
    // Controllers can now safely access services
    
    // Auth Controller - fenix:true means it will be recreated if disposed
    Get.lazyPut(() => AuthController(), fenix: true);

    // Profile Controller - MUST be initialized before AIController
    // AIController depends on ProfileController
    Get.put(ProfileController(), permanent: true);

    // AI Controller - depends on ProfileController (put after ProfileController)
    Get.put(AIController(), permanent: true);

    // Category Controller - used in CategoryPage
    Get.lazyPut(() => CategoryController(), fenix: true);

    // Recipe Controller - used in RecipePage
    Get.lazyPut(() => RecipeController(), fenix: true);

    // All Categories Controller - used in AllCategoriesPage
    Get.lazyPut(() => AllCategoriesController(), fenix: true);
    
    // Note: HomePageController is initialized separately in main.dart
    // because it requires LocalNotificationService's selectedNotificationStream

      // All Favourites Controller - used in AllFavouritesPage
    // Get.lazyPut(() => AllFavouritesController(), fenix: true);
  }
}