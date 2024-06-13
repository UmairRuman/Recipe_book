import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/view/recipe_page.dart';

class CategoryController extends GetxController {
  void navigateToRecipePage() => Get.toNamed(
        RecipePage.pageName,
      );
}
