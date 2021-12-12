import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

class FilterTasksFAB extends StatefulWidget {
  const FilterTasksFAB({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  _FilterTasksFABState createState() => _FilterTasksFABState();
}

class _FilterTasksFABState extends State<FilterTasksFAB> with SingleTickerProviderStateMixin, AnimationControllerMixin {
  Animation<Color> _colorAnimation;

  static const expandedSize = 180.0;

  @override
  void initState() {
    super.initState();
    _colorAnimation = ColorTween(begin: Colors.pink, end: Colors.pink[800]).animate(animationController);
  }

  void _toggle() {
    if (animationController.isDismissed) {
      animationController.forward();
    } else if (animationController.isCompleted) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: expandedSize,
      width: expandedSize,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (_, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildBackground(),
              child,
              _buildFAB(),
            ],
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildMenu(Icons.check_circle, 0.0, const Interval(0.6, 0.7)),
            _buildMenu(Icons.flash_on, -math.pi / 3, const Interval(0.7, 0.8)),
            _buildMenu(Icons.access_time, -2 * math.pi / 3, const Interval(0.8, 0.9)),
            _buildMenu(Icons.error_outline, math.pi, const Interval(0.9, 1.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(IconData icon, double angle, Curve interval) {
    return GestureDetector(
      onTap: () {
        widget.onPressed?.call();
        _toggle();
      },
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: kMinInteractiveDimension,
          height: kMinInteractiveDimension,
        ),
        child: Transform.rotate(
          angle: angle,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Transform.rotate(
                angle: -angle,
                child: ScaleTransition(
                  scale: CurveTween(curve: interval).animate(animationController),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: expandedSize * curvedAnimation.value,
      width: expandedSize * curvedAnimation.value,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
    );
  }

  Widget _buildFAB() {
    // the scale factor will transition from 1..0..1
    final scaleFactor = 2 * (animationController.value - 0.5).abs();
    return FloatingActionButton(
      onPressed: _toggle,
      backgroundColor: _colorAnimation.value,
      child: Transform.scale(
        scale: scaleFactor,
        // transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: Icon(
          animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  @override
  AnimationConfig get animationControllerConfig => AnimationConfig(
        vsync: this,
        curve: Curves.bounceOut,
      );
}
