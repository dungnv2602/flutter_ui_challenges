import 'package:flutter/material.dart';

class ImageHero extends StatelessWidget {
  final String tag;
  final double width;
  final double height;
  final BoxFit fit;
  final String imagePath;
  final VoidCallback onTap;

  const ImageHero(
      {Key key,
      @required this.tag,
      @required this.width,
      @required this.height,
      @required this.fit,
      @required this.imagePath,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Hero(
        tag: tag,
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              imagePath,
              fit: fit,
            ),
          ),
        ),
      ),
    );
  }
}
