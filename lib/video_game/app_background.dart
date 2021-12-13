import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Color backgroundColor;
  final Color firstCircleColor;
  final Color secondCircleColor;
  final Color thirdCircleColor;
  final AnimationController controller;
  final Animation animation;

  AppBackground({
    Key key,
    @required this.backgroundColor,
    @required this.firstCircleColor,
    @required this.secondCircleColor,
    @required this.thirdCircleColor,
    @required this.controller,
  })  : animation = Tween<double>(begin: 1.2, end: 0)
            .animate(CurvedAnimation(parent: controller, curve: Interval(0.5, 0.7, curve: Curves.easeIn))),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: <Widget>[
            Container(
              color: backgroundColor,
            ),
            _Circle(
              left: -width * 0.5,
              bottom: height * 0.2,
              size: height,
              color: firstCircleColor,
              animation: animation,
            ),
            _Circle(
              left: width * 0.2,
              bottom: height * 0.55,
              size: width * 1.2,
              color: secondCircleColor,
              animation: animation,
            ),
            _Circle(
              left: width * 0.5,
              bottom: height * 0.75,
              size: width,
              color: thirdCircleColor,
              animation: animation,
            ),
          ],
        );
      },
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final Color color;
  final double left;
  final double bottom;
  final Animation animation;

  const _Circle({
    Key key,
    @required this.size,
    @required this.color,
    @required this.left,
    @required this.bottom,
    @required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => Transform.rotate(
          angle: animation.value,
          origin: Offset(size / 2, size / 2),
          child: child,
        ),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
