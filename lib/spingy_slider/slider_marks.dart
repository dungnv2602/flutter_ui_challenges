import 'dart:ui';

import 'package:flutter/material.dart';

class SliderMarks extends StatelessWidget {
  final int markCount;
  final Color markColor;
  final Color backgroundColor;
  final double paddingTop;
  final double paddingBottom;
  final double paddingRight;

  const SliderMarks({
    Key key,
    @required this.markCount,
    @required this.markColor,
    @required this.backgroundColor,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.paddingRight = 16,
  })  : assert(markCount != null),
        assert(markColor != null),
        assert(backgroundColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: _SliderMarksPainter(
        markCount: markCount,
        markColor: markColor,
        backgroundColor: backgroundColor,
        paddingTop: paddingTop,
        paddingBottom: paddingBottom,
        paddingRight: paddingRight,
      ),
    );
  }
}

class _SliderMarksPainter extends CustomPainter {
  final double smallMarkWidth;
  final double largeMarkWidth;
  final double markThickness;
  final int markCount;
  final Color markColor;
  final Color backgroundColor;
  final double paddingTop;
  final double paddingBottom;
  final double paddingRight;
  final Paint markPaint;
  final Paint backgroundPaint;

  _SliderMarksPainter({
    this.markThickness = 1,
    this.smallMarkWidth = 10,
    this.largeMarkWidth = 30,
    @required this.markCount,
    @required this.markColor,
    @required this.backgroundColor,
    @required this.paddingTop,
    @required this.paddingBottom,
    @required this.paddingRight,
  })  : assert(markCount != null),
        assert(markColor != null),
        assert(backgroundColor != null),
        assert(paddingTop != null),
        assert(paddingBottom != null),
        assert(paddingRight != null),
        markPaint = Paint()
          ..color = markColor
          ..strokeWidth = markThickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        backgroundPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    /// draw the background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    /// draw the marks
    final paintHeight = size.height - paddingTop - paddingBottom;
    final gap = paintHeight / markCount;

    for (int i = 0; i < markCount; i++) {
      double markWidth = smallMarkWidth;
      if (i == 0 || i == markCount - 1) {
        // the top and bottom mark
        markWidth = largeMarkWidth;
      } else if (i == 1 || i == markCount - 2) {
        // the second top and bottom mark
        markWidth = lerpDouble(smallMarkWidth, largeMarkWidth, 0.5);
      }

      final markY = paddingTop + i * gap;

      // draw the mark on the right most
      canvas.drawLine(
        Offset(size.width - markWidth - paddingRight, markY),
        Offset(size.width - paddingRight, markY),
        markPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_SliderMarksPainter oldDelegate) =>
      markCount != oldDelegate.markCount ||
      markThickness != oldDelegate.markThickness ||
      markColor != oldDelegate.markColor ||
      paddingTop != oldDelegate.paddingTop ||
      paddingBottom != oldDelegate.paddingBottom;

  @override
  bool shouldRebuildSemantics(_SliderMarksPainter oldDelegate) => false;
}
