import 'package:flutter/material.dart';

class RecipeAppBarDesign extends StatelessWidget {
  const RecipeAppBarDesign({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                  'https://www.themealdb.com/images/media/meals/uvuyxu1503067369.jpg',
                ),
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
                opacity: 0.8),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: ButtonBar(
              children: [
                IconButton(
                    onPressed: () {
                      //set timer
                    },
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      //add to favourites list
                    },
                    icon: const Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
