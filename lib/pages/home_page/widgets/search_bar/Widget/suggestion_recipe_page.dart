import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionRecipePage extends StatelessWidget {
  const SuggestionRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    var arguments = Get.arguments.toString();
    return Scaffold(
      body: Center(
        child: Text(arguments),
      ),
    );
  }
}
