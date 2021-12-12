/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'springy_slider_controller.dart';

class SliderGoo extends StatelessWidget {
  final SpringySliderController sliderController;
  final double paddingTop;
  final double paddingBottom;
  final Widget child;

  const SliderGoo({
    Key key,
    @required this.child,
    @required this.sliderController,
    this.paddingTop = 0,
    this.paddingBottom = 0,
  })  : assert(sliderController != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SliderClipper(
        sliderController: sliderController,
        paddingTop: paddingTop,
        paddingBottom: paddingBottom,
      ),
      child: child,
    );
  }
}

class _SliderClipper extends CustomClipper<Path> {
  final SpringySliderController sliderController;
  final double paddingTop;
  final double paddingBottom;

  _SliderClipper({
    @required this.sliderController,
    @required this.paddingTop,
    @required this.paddingBottom,
  })  : assert(sliderController != null),
        assert(paddingTop != null),
        assert(paddingBottom != null);

  @override
  Path getClip(Size size) {
    switch (sliderController.state) {
      case SpringySliderState.idle:
        return _clipIdle(size);
      case SpringySliderState.dragging:
        return _clipDragging(size);
      case SpringySliderState.springing:
        return _clipSpringing(size);
      default:
        return _clipIdle(size);
    }
  }

  Path _clipIdle(Size size) {
    final top = paddingTop;
    final bottom = size.height;
    final height = bottom - paddingBottom - top;

    /// calculate the negative value
    final basePercentFromBottom = 1 - sliderController.sliderValue;
    final baseY = top + (basePercentFromBottom * height);

    final rect = Path();

    /// clip from the end of negative value to bottom
    rect.addRect(Rect.fromLTWH(
      0,
      baseY,
      size.width,
      bottom,
    ));

    return rect;
  }

  Path _clipSpringing(Size size) {
    final compositePath = Path();

    final top = paddingTop;
    final bottom = size.height - paddingBottom;
    final height = bottom - top;

    final basePercentFromBottom = 1 - sliderController.springingPercent;
    final crestSpringPercentFromBottom =
        1 - sliderController.crestSpringingPercent;

    final baseY = top + (basePercentFromBottom * height);
    final leftX = -0.85 * size.width;
    final rightX = 1.15 * size.width;
    final centerX = 0.15 * size.width;

    /// destination points is 15% left and right of the device
    final leftPoint = Point(leftX, baseY);
    final rightPoint = Point(rightX, baseY);
    final centerPoint = Point(centerX, baseY);

    final crestY = top + (crestSpringPercentFromBottom * height);
    final crestPoint = Point((rightX - centerX) / 2 + centerX, crestY);

    final troughY = baseY + (baseY - crestY);
    final troughPoint = Point((centerX - leftX) / 2 + leftX, troughY);

    const controlPointWidth = 100;

    ///clip rect
    final rect = Path()
      ..moveTo(leftPoint.x, leftPoint.y)
      ..lineTo(rightPoint.x, rightPoint.y)
      ..lineTo(rightPoint.x, size.height)
      ..lineTo(leftPoint.x, size.height)
      ..lineTo(leftPoint.x, leftPoint.y)
      ..close();

    compositePath.addPath(rect, Offset.zero);

    /// clip left curve
    final leftCurve = Path()
      // move to troughPoint
      ..moveTo(troughPoint.x, troughPoint.y)
      // clip bezier curve to leftPoint
      ..quadraticBezierTo(
        troughPoint.x - controlPointWidth,
        troughPoint.y,
        leftPoint.x,
        leftPoint.y,
      )
      // move to troughPoint
      ..moveTo(troughPoint.x, troughPoint.y)
      // clip bezier curve to centerPoint
      ..quadraticBezierTo(
        troughPoint.x + controlPointWidth,
        troughPoint.y,
        centerPoint.x,
        centerPoint.y,
      )
      // close path
      ..lineTo(leftPoint.x, leftPoint.y)
      ..close();

    if (crestSpringPercentFromBottom < basePercentFromBottom) {
      compositePath.fillType = PathFillType.evenOdd;
    }

    compositePath.addPath(leftCurve, Offset.zero);

    /// clip right curve
    final rightCurve = Path()
      // move to crestPoint
      ..moveTo(crestPoint.x, crestPoint.y)
      // clip bezier curve to centerPoint
      ..quadraticBezierTo(
        crestPoint.x - controlPointWidth,
        crestPoint.y,
        centerPoint.x,
        centerPoint.y,
      )
      // move to crestPoint
      ..moveTo(crestPoint.x, crestPoint.y)
      // clip bezier curve to rightPoint
      ..quadraticBezierTo(
        crestPoint.x + controlPointWidth,
        crestPoint.y,
        rightPoint.x,
        rightPoint.y,
      )
      // close path
      ..lineTo(centerPoint.x, centerPoint.y)
      ..close();

    if (crestSpringPercentFromBottom > basePercentFromBottom) {
      compositePath.fillType = PathFillType.evenOdd;
    }

    compositePath.addPath(rightCurve, Offset.zero);

    return compositePath;
  }

  Path _clipDragging(Size size) {
    final compositePath = Path();

    final top = paddingTop;
    final bottom = size.height - paddingBottom;
    final height = bottom - top;

    final basePercentFromBottom = 1 - sliderController.sliderValue;
    final dragPercentFromBottom = 1 - sliderController.draggingVerticalPercent;

    final baseY = top + (basePercentFromBottom * height);
    final leftX = -0.15 * size.width;
    final rightX = 1.15 * size.width;

    /// destination points is 15% left and right of the device
    final leftPoint = Point(leftX, baseY);
    final rightPoint = Point(rightX, baseY);

    /// where the gesture point in
    final dragX = sliderController.draggingHorizontalPercent * size.width;
    final dragY = top + (dragPercentFromBottom * height);

    /// crest point is at center of width and Y coordinate of dragging point
    final crestPoint = Point(dragX, dragY.clamp(top, bottom));

    /// determine the percent of dragging over the limits
    double excessDrag = 0;
    if (sliderController.draggingVerticalPercent < 0) {
      excessDrag = sliderController.draggingVerticalPercent;
    } else if (sliderController.draggingVerticalPercent > 1) {
      excessDrag = sliderController.draggingVerticalPercent - 1;
    }

    const baseControlPointWidth = 150;
    final thickeningFactor = excessDrag * height * 0.05;
    final controlPointWidth =
        (200 * thickeningFactor).abs() + baseControlPointWidth;

    ///clip rect
    final rect = Path()
      ..moveTo(leftPoint.x, leftPoint.y)
      ..lineTo(rightPoint.x, rightPoint.y)
      ..lineTo(rightPoint.x, size.height)
      ..lineTo(leftPoint.x, size.height)
      ..lineTo(leftPoint.x, leftPoint.y)
      ..close();

    compositePath.addPath(rect, Offset.zero);

    /// clip curve
    final curve = Path()
      // move to crestPoint
      ..moveTo(crestPoint.x, crestPoint.y)
      // clip bezier curve to leftPoint
      ..quadraticBezierTo(
        crestPoint.x - controlPointWidth,
        crestPoint.y,
        leftPoint.x,
        leftPoint.y,
      )
      // move to crestPoint
      ..moveTo(crestPoint.x, crestPoint.y)
      // clip bezier curve to rightPoint
      ..quadraticBezierTo(
        crestPoint.x + controlPointWidth,
        crestPoint.y,
        rightPoint.x,
        rightPoint.y,
      )
      //close path
      ..lineTo(leftPoint.x, leftPoint.y)
      ..close();

    if (dragPercentFromBottom > basePercentFromBottom) {
      compositePath.fillType = PathFillType.evenOdd;
    }

    compositePath.addPath(curve, Offset.zero);

    return compositePath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => this != oldClipper;
}
