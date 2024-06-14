// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:recipe_book/pages/home_page/widgets/cache_receipes.dart';
// import 'package:recipe_book/pages/home_page/widgets/category_list.dart';
// import 'package:recipe_book/pages/home_page/widgets/fav_list.dart';
// import 'package:recipe_book/pages/home_page/widgets/search_bar.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   static const pageAddress = '/';
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height;
//     final searchBarHeight = height * 0.1;
//     final categoryItemHeight = height * 0.25;
//     final favouriteReciepeItemHeight = height * 0.25;
//     final cacheReceipeItemHeight = height * 0.20;
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: 14,
//         itemBuilder: (BuildContext context, int index) {
//           if (index == 0) {
//             return SizedBox(
//                 height: searchBarHeight, child: const HomeSearchBarWidget());
//           } else if (index == 1) {
//             return SizedBox(
//                 height: categoryItemHeight, child: const CategoryReceipeList());
//           } else if (index == 2) {
//             return SizedBox(
//                 height: favouriteReciepeItemHeight,
//                 child: const FavouriteReciepeList());
//           } else if (index == 3) {
//             return const CacheReceipesTitle();
//           } else {
//             return SizedBox(
//                 height: cacheReceipeItemHeight,
//                 child: const CacheReceipesList());
//           }
//         },
//       ),
//     );
//   }
// }
