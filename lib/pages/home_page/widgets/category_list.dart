// import 'package:flutter/material.dart';
// import 'package:recipe_book/pages/category_page/model/category_model.dart';

// class CategoryReceipeList extends StatelessWidget {
//   const CategoryReceipeList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final size = constraints;
//         final categoryItemHeight = size.maxHeight * 0.7;
//         final categoryTitleHeight = size.maxHeight * 0.3;
//         final categoryItemWidth = size.maxWidth * 0.4;
//         final categoryTitlePadding = size.maxWidth * 0.01;
//         const categoryTitleText = 'Category';
//         const categoryTitleColor = Colors.black;
//         final categoryTitleFontSize = categoryTitleHeight * 0.5;
//         return Column(
//           children: [
//             SizedBox(
//                 height: categoryTitleHeight,
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: EdgeInsets.all(categoryTitlePadding),
//                     child: Text(
//                       categoryTitleText,
//                       style: TextStyle(
//                           color: categoryTitleColor,
//                           fontSize: categoryTitleFontSize),
//                     ),
//                   ),
//                 )),
//             SizedBox(
//               height: categoryItemHeight,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categoriesDummyList.length,
//                 itemBuilder: (context, index) {
//                   var currentCategory = categoriesDummyList[index];
//                   return SizedBox(
//                     width: categoryItemWidth,
//                     child: CategoryListItem(
//                       category: currentCategory,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class CategoryListItem extends StatelessWidget {
//   final CategoryModel category;
//   const CategoryListItem({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final padding = size.width * 0.01;
//     final itemBorderRadius = size.width * 0.07;
//     const itemTextColor = Colors.black;
//     const imageOpacity = 0.5;
//     return Padding(
//       padding: EdgeInsets.all(padding),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: NetworkImage(category.image),
//                 fit: BoxFit.cover,
//                 opacity: imageOpacity),
//             borderRadius: BorderRadius.circular(itemBorderRadius)),
//         child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Text(
//               category.recipeName,
//               style: const TextStyle(
//                   color: itemTextColor, fontWeight: FontWeight.bold),
//             )),
//       ),
//     );
//   }
// }
