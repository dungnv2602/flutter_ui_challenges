import 'package:flutter/material.dart';

class FadeSlideTransition extends StatelessWidget {
  const FadeSlideTransition({
    @required this.animation,
    this.additionalOffset,
    @required this.child,
  })  : assert(animation != null),
        assert(child != null);

  final double additionalOffset;
  final Animation<double> animation;
  final Widget child;

  static const baseAdditionalOffset = 32.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(
            0.0,
            (additionalOffset ?? 0) * (1 - animation.value),
          ),
          child: child,
        );
      },
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
