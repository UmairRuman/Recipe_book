// lib/navigation/app_routes.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/navigation/auth_middleware.dart';
import 'package:recipe_book/pages/all_categories_page/view/all_categories_page.dart';
import 'package:recipe_book/pages/Authentication_pages/main_auth_page.dart';
import 'package:recipe_book/pages/all_favourites_page/view/all_favourites_page.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/view/home_page.dart';
import 'package:recipe_book/pages/profile_page/edit_profile_page.dart';
import 'package:recipe_book/pages/profile_page/view/profile_page.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/pages/splash_screen/splash_screen.dart';

/// Route names as constants for type safety
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route names
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String allCategories = '/all-categories';
  static const String category = '/category';
  static const String recipe = '/recipe';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String allFavourites = '/all-favourites';

  // Initial route
  static const String initial = splash;
}

/// App Pages configuration with middleware
class AppPages {
  // Private constructor to prevent instantiation
  AppPages._();

  /// Get all app routes
  static List<GetPage> get pages => [
        // Splash Screen - No middleware (always accessible)
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashScreen(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 300),
          // NO middlewares here!
        ),
        // Authentication Page - Only accessible when NOT logged in
        GetPage(
          name: AppRoutes.auth,
          page: () => const AuthenticationPage(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
          middlewares: [
            AuthMiddleware(), // Redirects to home if already logged in
          ],
        ),

        // Home Page - Requires authentication
        GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
          middlewares: [
            AuthMiddleware(), // Checks if user is logged in
          ],
        ),

        // All Categories Page - Requires authentication
        // Controller is initialized via DependencyInjection.init()
        GetPage(
          name: AppRoutes.allCategories,
          page: () => const AllCategoriesPage(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
          middlewares: [
            AuthMiddleware(),
          ],
        ),

        // Category Page - Requires authentication
        GetPage(
          name: AppRoutes.category,
          page: () => const CategoryPage(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
          middlewares: [
            AuthMiddleware(),
          ],
        ),

        // Recipe Page - Requires authentication
        GetPage(
          name: AppRoutes.recipe,
          page: () => const RecipePage(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
          middlewares: [
            AuthMiddleware(),
          ],
        ),

       // Profile Page - Requires authentication  
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthMiddleware()],
    ),
    // Profile Edit Page - Requires authentication
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthMiddleware()],
    ),

      GetPage(
      name: AppRoutes.allFavourites,
      page: () => const AllFavouritesPage(),
      transition: Transition.rightToLeft,
      middlewares: [AuthMiddleware()],
    ),
      ];
}