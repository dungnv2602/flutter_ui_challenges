import 'package:flutter/material.dart';
import 'springy_slider_controller.dart';

class SliderPoints extends StatelessWidget {
  final SpringySliderController sliderController;
  final Color topColor;
  final Color bottomColor;
  final double paddingTop;
  final double paddingBottom;

  const SliderPoints({
    Key key,
    @required this.sliderController,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    @required this.topColor,
    @required this.bottomColor,
  })  : assert(sliderController != null),
        assert(topColor != null),
        assert(bottomColor != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        double sliderPercent = sliderController.sliderValue;
        if (sliderController.state == SpringySliderState.dragging) {
          sliderPercent = sliderController.draggingVerticalPercent.clamp(0.0, 1.0);
        }

        final height = constraints.maxHeight - paddingTop - paddingBottom;
        final sliderY = height * (1 - sliderPercent) + paddingTop;

        final pointsYouHaveInPercent = sliderPercent;
        final pointsYouHave = (100 * pointsYouHaveInPercent).round();

        final pointsYouNeedInPercent = 1 - pointsYouHaveInPercent;
        final pointsYouNeed = 100 - pointsYouHave;

        return Stack(
          children: <Widget>[
            /// top number
            Positioned(
              left: 32,
              top: sliderY - 10 - (40 * pointsYouHaveInPercent),
              child: FractionalTranslation(
                translation: const Offset(0.0, -1.0),
                child: Points(
                  points: pointsYouNeed,
                  pointsInPercent: pointsYouNeedInPercent,
                  isAboveSlider: true,
                  isPointsYouNeed: true,
                  color: topColor,
                ),
              ),
            ),

            /// bottom number
            Positioned(
              left: 32,
              top: sliderY + 10 + (40 * pointsYouNeedInPercent),
              child: Points(
                points: pointsYouHave,
                pointsInPercent: pointsYouHaveInPercent,
                isAboveSlider: false,
                isPointsYouNeed: false,
                color: bottomColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Points extends StatelessWidget {
  final int points;
  final double pointsInPercent;
  final bool isAboveSlider;
  final bool isPointsYouNeed;
  final Color color;

  const Points({
    Key key,
    @required this.points,
    @required this.pointsInPercent,
    this.isAboveSlider = true,
    this.isPointsYouNeed = true,
    this.color,
  })  : assert(points != null),
        assert(pointsInPercent != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final pointTextSize = 50 + (50 * pointsInPercent);
    return Row(
      crossAxisAlignment: isAboveSlider ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        FractionalTranslation(
          // font sensitive
          translation: Offset(-0.05 * pointsInPercent, isAboveSlider ? 0.18 : -0.18),
          child: Text(
            '$points',
            style: TextStyle(
              fontSize: pointTextSize,
              color: color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'POINTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Text(
                isPointsYouNeed ? 'YOU NEED' : 'YOU HAVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
