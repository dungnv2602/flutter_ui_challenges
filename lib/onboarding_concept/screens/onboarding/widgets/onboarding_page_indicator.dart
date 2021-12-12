import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../constants.dart';

/// https://uxdesign.cc/flutter-design-challenge-onboarding-concept-1f5774d55646
class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    @required this.startAngle,
    @required this.currentPage,
    @required this.child,
  })  : assert(startAngle != null),
        assert(currentPage != null),
        assert(child != null);

  /// angle which drives indicators forward
  /// expect this value range from [-2 * pi...2 * pi] which is entire circle radius
  final double startAngle;

  final Widget child;

  final int currentPage;

  Color _getPageIndicatorColor(int pageIndex) => currentPage > pageIndex ? kWhite : kWhite.withOpacity(0.25);

  double get _indicatorLength => 1 / 3 * math.pi;

  double get _indicatorGap => 1 / 12 * math.pi; // the gap to differentiate indicators

  double get _baseIndicatorStartAngle => 4 * _indicatorLength;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OnboardingPageIndicatorPainter(
        startAngle: _baseIndicatorStartAngle - _indicatorLength - _indicatorGap + startAngle,
        sweepAngle: _indicatorLength,
        color: _getPageIndicatorColor(0),
      ),
      child: CustomPaint(
        painter: _OnboardingPageIndicatorPainter(
          startAngle: _baseIndicatorStartAngle + startAngle,
          sweepAngle: _indicatorLength,
          color: _getPageIndicatorColor(1),
        ),
        child: CustomPaint(
          painter: _OnboardingPageIndicatorPainter(
            startAngle: _baseIndicatorStartAngle + _indicatorLength + _indicatorGap + startAngle,
            sweepAngle: _indicatorLength,
            color: _getPageIndicatorColor(2),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _OnboardingPageIndicatorPainter extends CustomPainter {
  _OnboardingPageIndicatorPainter({
    @required this.startAngle,
    @required this.sweepAngle,
    @required this.color,
    this.strokeWidth = 4,
    this.padding = 6,
  })  : _painter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
        assert(color != null),
        assert(startAngle != null),
        assert(sweepAngle != null);

  final Color color;
  final double padding;
  final double startAngle;
  final double strokeWidth;
  final double sweepAngle;

  final Paint _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 + padding;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      _painter,
    );
  }

  @override
  bool shouldRebuildSemantics(_OnboardingPageIndicatorPainter oldDelegate) =>
      color != oldDelegate.color || startAngle != oldDelegate.startAngle;

  @override
  bool shouldRepaint(_OnboardingPageIndicatorPainter oldDelegate) =>
      color != oldDelegate.color || startAngle != oldDelegate.startAngle;
}
