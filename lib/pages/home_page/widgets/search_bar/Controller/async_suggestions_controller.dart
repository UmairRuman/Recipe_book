import 'package:get/get.dart';

class AsyncSuggestionsController extends GetxController {
  var isLoading = false.obs;
  var suggestions = <String>[].obs;
  var searchedText = "".obs;

  void updateSuggestions(List<String> newSuggestions) {
    suggestions.assignAll(newSuggestions);
  }
}
