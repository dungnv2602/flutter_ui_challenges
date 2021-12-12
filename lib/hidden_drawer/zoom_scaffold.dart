import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/animation/index.dart';
import 'package:sized_context/sized_context.dart';

const _kScaleDownCurve = Interval(0, 0.3, curve: Curves.easeOut);
const _kSlideOutCurve = Curves.easeOut;
const _kScaleUpCurve = Curves.easeIn;
const _kSlideInCurve = Curves.easeIn;

const _defaultBoxShadow = BoxShadow(
  color: Color(0x44000000),
  offset: Offset(0, 0.5),
  blurRadius: 20,
  spreadRadius: 10,
);

class ZoomScaffold extends AnimatedWidget {
  const ZoomScaffold({
    Key key,
    this.translationRatio = 0.7,
    this.scaleRatio = 0.2,
    this.scaleDownCurve = _kScaleDownCurve,
    this.slideOutCurve = _kSlideOutCurve,
    this.scaleUpCurve = _kScaleUpCurve,
    this.slideInCurve = _kSlideInCurve,
    @required this.openableController,
    @required this.child,
  }) : super(key: key, listenable: openableController);

  final Curve scaleDownCurve;
  final double scaleRatio;
  final Curve scaleUpCurve;
  final Curve slideInCurve;
  final Curve slideOutCurve;
  final double translationRatio;
  final OpenableController openableController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final menuPercent = openableController.value;

    double translationValue;
    double scaleValue;

    switch (openableController.state) {
      case OpenableState.opened:
      case OpenableState.opening:
        translationValue = context.widthPx *
            translationRatio *
            slideOutCurve.transform(menuPercent);
        scaleValue = 1 - scaleRatio * scaleDownCurve.transform(menuPercent);
        break;
      case OpenableState.closed:
      case OpenableState.closing:
        translationValue = context.widthPx *
            translationRatio *
            slideInCurve.transform(menuPercent);
        scaleValue = 1 - scaleRatio * scaleUpCurve.transform(menuPercent);
        break;
    }

    return Transform(
      transform: Matrix4.translationValues(
        translationValue,
        0,
        0,
      )..scale(scaleValue, scaleValue),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            _defaultBoxShadow,
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: child,
        ),
      ),
    );
  }
}
