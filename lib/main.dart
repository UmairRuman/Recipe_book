import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/view/category_view_page.dart';
import 'package:recipe_book/pages/home_page/controller/home_page_controller.dart';
import 'package:recipe_book/pages/home_page/view/home_page.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';
import 'package:recipe_book/services/notification_services/local_notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().initializeNotifications();
  tz.initializeTimeZones();
  Get.put(HomePageController());
  runApp(const MyApp());
}

//!timer ka bas gradle set krna hay aur baki category page ki app bar set krni hay
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
          name: HomePage.pageAddress,
          page: () => const HomePage(),
        ),
        GetPage(
          name: CategoryPage.pageAddress,
          page: () => const CategoryPage(),
        ),
        GetPage(
          name: RecipePage.pageAddress,
          page: () => const RecipePage(),
        )
      ],
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
