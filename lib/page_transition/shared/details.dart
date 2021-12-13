import 'package:flutter/material.dart';

import 'models.dart';
import 'shared.dart';

class AnimatedDetails extends StatefulWidget {
  final DestinationModel model;
  final ViewState viewState;
  final double enlargedFontSize;
  final double enlargedIconSize;

  const AnimatedDetails({
    Key key,
    @required this.model,
    @required this.viewState,
    this.enlargedFontSize = 15.0,
    this.enlargedIconSize = 24.0,
  }) : super(key: key);

  @override
  _AnimatedDetailsState createState() => _AnimatedDetailsState();
}

class _AnimatedDetailsState extends State<AnimatedDetails> with SingleTickerProviderStateMixin {
  AnimationController controller;

  Animation opacityTween;
  Animation fontSizeTween;
  Animation iconSizeTween;
  Animation<Color> fontColorTween;
  Animation<Color> iconColorTween;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: animationDuration);

    double opacityBegin, opacityEnd;
    double fontSizeBegin, fontSizeEnd;
    double iconSizeBegin, iconSizeEnd;
    Color fontColorBegin, fontColorEnd;
    Color iconColorBegin, iconColorEnd;

    switch (widget.viewState) {
      case ViewState.enlarge:
        opacityBegin = 0.0;
        opacityEnd = 1.0;
        fontSizeBegin = 0.0;
        fontSizeEnd = widget.enlargedFontSize;
        iconSizeBegin = 0.0;
        iconSizeEnd = widget.enlargedIconSize;
        fontColorBegin = Colors.transparent;
        fontColorEnd = Colors.black54;
        iconColorBegin = Colors.transparent;
        iconColorEnd = Colors.black;
        break;
      case ViewState.enlarged:
        opacityBegin = 1.0;
        opacityEnd = 1.0;
        fontSizeBegin = widget.enlargedFontSize;
        fontSizeEnd = widget.enlargedFontSize;
        iconSizeBegin = widget.enlargedIconSize;
        iconSizeEnd = widget.enlargedIconSize;
        fontColorBegin = Colors.black54;
        fontColorEnd = Colors.black54;
        iconColorBegin = Colors.black;
        iconColorEnd = Colors.black;
        break;
      case ViewState.shrink:
        opacityBegin = 1.0;
        opacityEnd = 0.0;
        fontSizeBegin = widget.enlargedFontSize;
        fontSizeEnd = 0.0;
        iconSizeBegin = widget.enlargedIconSize;
        iconSizeEnd = 0.0;
        fontColorBegin = Colors.black54;
        fontColorEnd = Colors.transparent;
        iconColorBegin = Colors.black;
        iconColorEnd = Colors.transparent;
        break;
      case ViewState.shrunk:
        opacityBegin = 0.0;
        opacityEnd = 0.0;
        fontSizeBegin = 0.0;
        fontSizeEnd = 0.0;
        iconSizeBegin = 0.0;
        iconSizeEnd = 0.0;
        fontColorBegin = Colors.transparent;
        fontColorEnd = Colors.transparent;
        iconColorBegin = Colors.transparent;
        iconColorEnd = Colors.transparent;
        break;
    }

    final curve = CurvedAnimation(parent: controller, curve: Curves.easeInQuint);

    opacityTween = Tween(begin: opacityBegin, end: opacityEnd).animate(curve);

    fontSizeTween = Tween(begin: fontSizeBegin, end: fontSizeEnd).animate(curve);

    iconSizeTween = Tween(begin: iconSizeBegin, end: iconSizeEnd).animate(curve);

    fontColorTween = ColorTween(begin: fontColorBegin, end: fontColorEnd).animate(curve);

    iconColorTween = ColorTween(begin: iconColorBegin, end: iconColorEnd).animate(curve);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Material(
        child: Opacity(
          opacity: opacityTween.value,
          child: Transform.scale(
            scale: opacityTween.value,
            alignment: Alignment.topCenter,
            child: Details(
              model: widget.model,
              fontSize: fontSizeTween.value,
              iconSize: iconSizeTween.value,
              fontColor: fontColorTween.value,
              iconColor: iconColorTween.value,
            ),
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final DestinationModel model;
  final double fontSize;
  final double iconSize;
  final Color fontColor;
  final Color iconColor;

  const Details({
    Key key,
    @required this.model,
    @required this.fontSize,
    @required this.iconSize,
    @required this.fontColor,
    @required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          model.description,
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor,
          ),
        ),
        SizedBox(height: fontSize),
        ActionRows(
          fontSize: fontSize,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ],
    );
  }
}

class ActionRows extends StatelessWidget {
  final double fontSize;
  final double iconSize;
  final Color iconColor;

  const ActionRows({
    Key key,
    @required this.fontSize,
    @required this.iconSize,
    @required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.person_outline,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(
          width: iconSize,
        ),
        Icon(
          Icons.alarm,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(
          width: iconSize,
        ),
        Icon(
          Icons.content_cut,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(
          width: iconSize,
        ),
        Text(
          'More',
          style: TextStyle(
            fontSize: fontSize,
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
