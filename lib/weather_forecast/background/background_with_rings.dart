/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import '../constants.dart';

const _circles = [
  _Circle(radius: baseCircleRadius, alpha: 0x10),
  _Circle(radius: baseCircleRadius + 15, alpha: 0x28),
  _Circle(radius: baseCircleRadius + 30, alpha: 0x38),
  _Circle(radius: baseCircleRadius + 75, alpha: 0x50),
];

const _offset = Offset(centerPoint, 0);

class BackgroundWithRings extends StatelessWidget {
  const BackgroundWithRings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'assets/images/weather_forecast/weather-bk_enlarged.png',
          fit: BoxFit.cover,
        ),
        ClipOval(
          clipper: const _CircleClipper(
            radius: baseCircleRadius,
            offset: _offset,
          ),
          child: Image.asset(
            'assets/images/weather_forecast/weather-bk.png',
            fit: BoxFit.cover,
          ),
        ),
        CustomPaint(
          painter: _WhiteCircleCutOutPainter(
            offset: _offset,
            circles: _circles,
          ),
        )
      ],
    );
  }
}

class _Circle {
  const _Circle({
    @required this.radius,
    @required this.alpha,
  })  : assert(radius != null),
        assert(alpha != null);

  final int alpha;
  final double radius;
}

Offset _centerLeftOffset(Size size, Offset offset) {
  return Offset(0, size.height / 2) + offset;
}

Rect _fullscreenRect(Size size) {
  return Rect.fromLTWH(0, 0, size.width, size.height);
}

class _CircleClipper extends CustomClipper<Rect> {
  const _CircleClipper({
    this.radius = 140,
    this.offset = const Offset(40, 0),
  });

  final Offset offset;
  final double radius;

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: _centerLeftOffset(size, offset),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) =>
      offset != oldClipper.offset || radius != oldClipper.radius;
}

/// Should rewatch the tutorial if still confuse what this is about.
class _WhiteCircleCutOutPainter extends CustomPainter {
  _WhiteCircleCutOutPainter({
    this.circles = const [],
    this.offset = const Offset(40, 0),
    this.baseColor = const Color(0xFFAA88AA),
  })  : _colorCirclePaint = Paint(),
        _borderCirclePaint = Paint()
          ..color = const Color(0x10FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

  final List<_Circle> circles;
  final Color baseColor;
  final Offset offset;

  final Paint _colorCirclePaint;
  final Paint _borderCirclePaint;

  void _maskCircle(Canvas canvas, Size size, double radius) {
    final clippedCircle = Path()
      ..fillType = PathFillType.evenOdd
      // the first shape is entire screen
      ..addRect(_fullscreenRect(size))
      // because fillType = PathFillType.evenOdd => the next shape added will be masked out
      ..addOval(
        Rect.fromCircle(
          center: _centerLeftOffset(size, offset),
          radius: radius,
        ),
      );

    /// where you allow to paint
    canvas.clipPath(clippedCircle);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // draw circles
    for (int i = 1; i < circles.length; i++) {
      final outerCircleRadius = circles[i].radius;
      final innerCircleRadius = circles[i - 1].radius;
      final innerCircleColor = baseColor.withAlpha(circles[i - 1].alpha);

      // allow to paint entire screen except the circle that has been cut out
      // in this case it is the circle before index i
      _maskCircle(canvas, size, innerCircleRadius);
      // draw fill circle (index i) to fill the rest of the screen
      canvas.drawCircle(
        _centerLeftOffset(size, offset),
        outerCircleRadius,
        _colorCirclePaint..color = innerCircleColor,
      );
      // draw fill circle bevel
      canvas.drawCircle(
        _centerLeftOffset(size, offset),
        innerCircleRadius,
        _borderCirclePaint,
      );
    }

    // draw final circle
    final finalCircle = circles.last;
    // mask the area of final circle
    _maskCircle(canvas, size, finalCircle.radius);
    // draw an overlay that fills the rest of screen
    canvas.drawRect(
      _fullscreenRect(size),
      _colorCirclePaint..color = baseColor.withAlpha(finalCircle.alpha),
    );
    // draw the bevel for the final circle
    canvas.drawCircle(
      _centerLeftOffset(size, offset),
      finalCircle.radius,
      _borderCirclePaint,
    );
  }

  @override
  bool shouldRebuildSemantics(_WhiteCircleCutOutPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor ||
      circles != oldDelegate.circles ||
      offset != oldDelegate.offset;

  @override
  bool shouldRepaint(_WhiteCircleCutOutPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor ||
      circles != oldDelegate.circles ||
      offset != oldDelegate.offset;
}
