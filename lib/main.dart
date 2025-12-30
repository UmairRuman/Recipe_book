// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:recipe_book/navigation/app_routes.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';
import 'package:recipe_book/utils/dependency_injection.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== Initialize Firebase ====================
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ==================== Initialize Timezones ====================
  tz.initializeTimeZones();

  // ==================== Initialize Local Notifications ====================
  final LocalNotificationService localNotifications = LocalNotificationService();
  await localNotifications.initializeNotifications();

  // ==================== Dependency Injection ====================
  // Initialize all services and controllers (includes AuthService and SecureStorage)
  await DependencyInjection.init();

  // Initialize HomePageController separately (needs notification stream)
  Get.put(
    HomePageController(
      selectedNotificationStream: localNotifications.selectedNotificationStream,
    ),
  );

  // ==================== Determine Initial Route ====================
  // Check if user is logged in and if app was opened from notification
  final String initialRoute = await localNotifications.getInitialRoute();

  debugPrint('🚀 App starting with initial route: $initialRoute');

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      
      // ==================== Theme ====================
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      
      // ==================== Routes ====================
      initialRoute: initialRoute, // Dynamic initial route based on auth state
      getPages: AppPages.pages,   // All routes with middleware
      
      // ==================== Default Transition ====================
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}