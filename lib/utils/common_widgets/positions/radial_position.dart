import 'dart:math';

import 'package:flutter/material.dart';

class RadialPosition extends StatelessWidget {
  final double radius;
  final double angle;
  final Widget child;

  const RadialPosition({
    Key key,
    this.radius = 0,
    this.angle = 0,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final x = cos(angle) * radius;
    final y = sin(angle) * radius;

    return Transform(
      transform: Matrix4.translationValues(x, y, 0),
      child: child,
    );
  }
}
