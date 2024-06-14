import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget {
  const AppBarDesign({super.key, required this.categoryImage});
  final String categoryImage;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final borderRadius = Radius.circular(constraints.maxWidth * 0.15);
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(3, 3))
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: borderRadius,
              bottomRight: borderRadius,
            ),
            image: DecorationImage(
                image: NetworkImage(
                  categoryImage,
                ),
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
                opacity: 0.8),
          ),
        );
      },
    );
  }
}
