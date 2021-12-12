import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Ripple extends StatelessWidget {
  const Ripple({
    @required this.animation,
    this.position,
    this.color,
    this.child,
  }) : assert(animation != null);

  final Animation<double> animation;
  final Widget child;
  final Color color;
  final Offset position;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final defaultHeight = height - 64.0;
    final defaultWidth = width / 2;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        final value = height * animation.value;
        return Positioned(
          left: (position?.dx ?? defaultWidth) - value,
          top: (position?.dy ?? defaultHeight) - value,
          child: Container(
            width: 2 * value,
            height: 2 * value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Theme.of(context).primaryColor,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
