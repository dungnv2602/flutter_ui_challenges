import 'package:flutter/material.dart';

import 'shared.dart';

class AnimatedHeader extends StatefulWidget {
  final ViewState viewState;
  final double smallFontSize;
  final double largeFontSize;
  final double smallIconSize;
  final double largeIconSize;

  const AnimatedHeader({
    Key key,
    this.viewState,
    this.smallFontSize = 20.0,
    this.largeFontSize = 48.0,
    this.smallIconSize = 24.0,
    this.largeIconSize = 0.0,
  }) : super(key: key);

  @override
  _AnimatedHeaderState createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader> with TickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _curve;
  Animation<double> _fontSizeTween;
  Animation<double> _iconSizeTween;
  Animation<double> _paddingSizeTween;
  Animation<double> _rotationTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: animationDuration);

    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    double fontSizeBegin,
        fontSizeEnd,
        iconSizeBegin,
        iconSizeEnd,
        paddingSizeBegin,
        paddingSizeEnd,
        rotationBegin,
        rotationEnd;

    switch (widget.viewState) {
      case ViewState.enlarge:
        fontSizeBegin = widget.smallFontSize;
        fontSizeEnd = widget.largeFontSize;

        iconSizeBegin = widget.smallIconSize;
        iconSizeEnd = widget.largeIconSize;

        paddingSizeBegin = 8;
        paddingSizeEnd = 0;

        rotationBegin = 0;
        rotationEnd = 1;
        break;

      case ViewState.enlarged:
        fontSizeBegin = widget.largeFontSize;
        fontSizeEnd = widget.largeFontSize;

        iconSizeBegin = widget.largeIconSize;
        iconSizeEnd = widget.largeIconSize;

        paddingSizeBegin = 0;
        paddingSizeEnd = 0;

        rotationBegin = 1;
        rotationEnd = 1;
        break;

      case ViewState.shrink:
        fontSizeBegin = widget.largeFontSize;
        fontSizeEnd = widget.smallFontSize;

        iconSizeBegin = widget.largeIconSize;
        iconSizeEnd = widget.smallIconSize;

        paddingSizeBegin = 0;
        paddingSizeEnd = 8;

        rotationBegin = 1;
        rotationEnd = 0;
        break;

      case ViewState.shrunk:
        fontSizeBegin = widget.smallFontSize;
        fontSizeEnd = widget.smallFontSize;

        iconSizeBegin = widget.smallIconSize;
        iconSizeEnd = widget.smallIconSize;

        paddingSizeBegin = 8;
        paddingSizeEnd = 8;

        rotationBegin = 0;
        rotationEnd = 0;
        break;
    }

    _fontSizeTween = Tween<double>(
      begin: fontSizeBegin,
      end: fontSizeEnd,
    ).animate(_curve);

    _iconSizeTween = Tween<double>(
      begin: iconSizeBegin,
      end: iconSizeEnd,
    ).animate(_curve);

    _paddingSizeTween = Tween<double>(
      begin: paddingSizeBegin,
      end: paddingSizeEnd,
    ).animate(_curve);

    _rotationTween = Tween<double>(
      begin: rotationBegin,
      end: rotationEnd,
    ).animate(_curve);

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 2.0,
            height: 50.0,
            color: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 16.0,
              height: 1.0,
              color: Colors.grey[700],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => RotationTransition(
              turns: _rotationTween,
              child: Image.asset(
                'assets/images/page_transition/sunny.png',
                width: _iconSizeTween.value,
                height: _iconSizeTween.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Padding(
              padding: EdgeInsets.only(left: _paddingSizeTween.value),
              child: Text(
                'Malaysia',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _fontSizeTween.value,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
