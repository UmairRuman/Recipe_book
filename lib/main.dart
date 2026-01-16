// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // ==================== Initialize Timezones ====================
  tz.initializeTimeZones();

  // ==================== Initialize Local Notifications ====================
  final LocalNotificationService localNotifications = LocalNotificationService();
  await localNotifications.initializeNotifications();

  // ==================== Dependency Injection ====================
  await DependencyInjection.init();

  // Initialize HomePageController separately
  Get.put(
    HomePageController(
      selectedNotificationStream: localNotifications.selectedNotificationStream,
    ),
  );

  // ==================== Check Notification Launch ====================
  // Store notification launch info but don't navigate yet
  final notificationLaunchInfo = await localNotifications.getNotificationLaunchInfo();
  
  if (notificationLaunchInfo != null) {
    debugPrint('📱 App launched from notification with payload: $notificationLaunchInfo');
    // Store for later use after splash
    Get.put(notificationLaunchInfo, tag: 'notification_payload');
  }

  debugPrint('🚀 App starting with splash screen');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: AppRoutes.initial, // ALWAYS start with splash
      getPages: AppPages.pages,
      
      // ==================== Default Transition ====================
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}