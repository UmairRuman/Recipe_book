import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget {
  const AppBarDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const url =
            'https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg';
        final borderRadius = Radius.circular(constraints.maxWidth * 0.15);
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: borderRadius,
              bottomRight: borderRadius,
            ),
            image: const DecorationImage(
                image: NetworkImage(
                  url,
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
