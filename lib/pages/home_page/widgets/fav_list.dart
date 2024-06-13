import 'package:flutter/material.dart';

class FavouriteReciepeList extends StatelessWidget {
  const FavouriteReciepeList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints;
        final favouriteItemWidth = size.maxWidth * 0.55;
        final favouriteItemHeight = size.maxHeight * 0.7;
        final favouriteTitleTextHeight = size.maxHeight * 0.3;
        final favouriteTitleTextFontSize = favouriteTitleTextHeight * 0.5;
        const favouriteTitleTextColor = Colors.black;
        const favouriteTitleText = 'Favourite';
        final favouriteTitleTextPadding = size.maxHeight * 0.01;
        return Column(
          children: [
            SizedBox(
              height: favouriteTitleTextHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(favouriteTitleTextPadding),
                  child: Text(
                    favouriteTitleText,
                    style: TextStyle(
                        color: favouriteTitleTextColor,
                        fontSize: favouriteTitleTextFontSize),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: favouriteItemHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: favouriteItemWidth, child: const FavListItem());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class FavListItem extends StatelessWidget {
  const FavListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = size.width * 0.01;
    final itemBorderRadius = size.width * 0.07;
    const imageOpacity = 0.4;
    const textColor = Colors.white;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage('assets/images/chickenkorma.jpg'),
                fit: BoxFit.cover,
                opacity: imageOpacity),
            borderRadius: BorderRadius.circular(itemBorderRadius)),
        child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'chicken dish',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
