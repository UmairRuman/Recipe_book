import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/recipe_page/controller/recipe_controller.dart';

class TimerMessageDialog extends GetView<RecipeController> {
  const TimerMessageDialog({super.key});
  static const btnText = 'OK';
  static const _lableText = 'Timer Messsage';
  static const _borders = OutlineInputBorder(
      borderRadius: BorderRadius.all(
    Radius.circular(
      20,
    ),
  ));
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth * 0.8,
          height: constraints.maxHeight * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      width: constraints.maxWidth * 0.6,
                      child: TextFormField(
                        controller: controller.timerMessageController,
                        decoration: const InputDecoration(
                            border: _borders,
                            focusedBorder: _borders,
                            enabledBorder: _borders,
                            labelText: _lableText),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextButton(
                        onPressed: controller.onOkBtnTap,
                        child: const Text(btnText)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
