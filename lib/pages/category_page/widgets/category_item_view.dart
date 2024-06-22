import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:recipe_book/pages/category_page/controller/category_controller.dart';
import 'package:recipe_book/pages/category_page/model/category_model.dart';

class CategoryItemView extends StatefulWidget {
  const CategoryItemView(
      {super.key, required this.category, required this.index});
  final CategoryItem category;
  final int index;
  static const shadows = [
    BoxShadow(
        color: Colors.black54,
        blurRadius: 20,
        spreadRadius: 5,
        offset: Offset(3, 3))
  ];
  static const recipeNamePaddingFromTop = 0.3;
  static const recipeNamePaddingFromLeft = 0.05;
  static const favIconSpacingFromTop = 0.1;
  static const favIconSpacingFromRight = 0.08;
  static const avatarRadius = 0.08;
  static const btnText = 'See Recipe';

  @override
  State<CategoryItemView> createState() => _CategoryItemViewState();
}

class _CategoryItemViewState extends State<CategoryItemView> {
  final controller = Get.find<CategoryController>();
  void rebuildPage() => setState(() {});
  void _onBtnTap() {
    controller.navigateToRecipePage(
        widget.category.strMeal, widget.index, rebuildPage);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) => controller.checkForFavouriteIcon(
          widget.category.idMeal, widget.index),
    );
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final recipeStyle = TextStyle(
        color: Colors.black,
        fontSize: height * 0.025,
        fontWeight: FontWeight.bold);
    return Center(
      child: Container(
        width: width * 0.8,
        height: height * 0.4,
        decoration: BoxDecoration(
          boxShadow: CategoryItemView.shadows,
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            width * 0.05,
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox.expand(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: height * CategoryItemView.avatarRadius,
                          backgroundImage: NetworkImage(
                            widget.category.strMealThumb,
                          ),
                        ),
                        Positioned(
                            top: constraints.maxHeight *
                                CategoryItemView.favIconSpacingFromTop,
                            right: constraints.maxWidth *
                                CategoryItemView.favIconSpacingFromRight,
                            child: IconButton(
                                onPressed: () {
                                  log(widget.category.toString());
                                  controller.onFavouriteIconTap(
                                      widget.category, widget.index);
                                },
                                icon: Obx(
                                  () => controller.iconsList[widget.index],
                                )))
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: SizedBox.expand(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Padding(
                      padding: EdgeInsets.only(
                          top: constraints.maxHeight *
                              CategoryItemView.recipeNamePaddingFromTop,
                          left: constraints.maxWidth *
                              CategoryItemView.recipeNamePaddingFromLeft),
                      child: Text(
                        widget.category.strMeal,
                        style: recipeStyle,
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: _onBtnTap,
                    child: const Text(CategoryItemView.btnText),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
