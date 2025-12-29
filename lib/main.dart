import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/Authentication_pages/main_auth_page.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/view/home_page.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/pages/splash_screen/splash_screen.dart';
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

  // ==================== Initialize Local Notifications ====================
  final LocalNotificationService localNotifications = LocalNotificationService();
  await localNotifications.initializeNotifications();
  tz.initializeTimeZones();

  // ==================== Dependency Injection ====================
  // Initialize all services and controllers
  await DependencyInjection.init();

  // Initialize HomePageController separately (needs notification stream)
  Get.put(
    HomePageController(
      selectedNotificationStream: localNotifications.selectedNotificationStream,
    ),
  );

  // ==================== Determine Initial Page ====================
  // Check if app was opened from notification
  Widget initialPage = await localNotifications.getInitialPage();

  runApp(MyApp(initialPage: initialPage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialPage});
  final Widget initialPage;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // ==================== Routes ====================
      initialRoute: '/splash', // Start with splash screen
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/auth',
          page: () => const AuthenticationPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/category',
          page: () => const CategoryPage(),
        ),
        GetPage(
          name: '/recipe',
          page: () => const RecipePage(),
        ),
      ],
      // Use initialPage if opened from notification, otherwise use initialRoute
      home: initialPage,
    );
  }
}