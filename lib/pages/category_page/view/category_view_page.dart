import 'package:flutter/material.dart';

class CategoryViewPage extends StatelessWidget {
  const CategoryViewPage({super.key});
  static const pageName = '/category';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: constraints.maxHeight * 0.25,
              collapsedHeight: constraints.maxHeight * 0.1,
              pinned: true,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
