import 'dart:math';

import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  const PageReveal({
    Key key,
    this.revealPercent = 0,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    final epiCenter = Offset(size.width / 2, size.height * 0.97);
    // TODO(joe): study trigonometry to understand this
    // Calculate distance from epicenter to the top left corner to make sure we fill the screen.
    final theta = atan(epiCenter.dy / epiCenter.dx);
    final distanceToCorner = epiCenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;

    return Rect.fromCircle(center: epiCenter, radius: radius);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => this != oldClipper;
}
