import 'package:flutter/material.dart';

enum ViewState {
  enlarge,
  enlarged,
  shrink,
  shrunk,
}

class HeroTextPush extends StatelessWidget {
  final String text;
  final String tag;
  final TextStyle textStyle;
  final double shrunkSize;
  final double enlargedSize;

  const HeroTextPush({
    Key key,
    @required this.text,
    @required this.tag,
    @required this.textStyle,
    @required this.shrunkSize,
    @required this.enlargedSize,
  })  : assert(text != null),
        assert(tag != null),
        assert(textStyle != null),
        assert(shrunkSize != null),
        assert(enlargedSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: _HeroText(
        text: text,
        textStyle: textStyle,
        shrunkSize: shrunkSize,
        enlargedSize: enlargedSize,
        viewState: ViewState.shrunk,
      ),
      flightShuttleBuilder: (_, animation, direction, __, ___) {
        return _HeroText(
          text: text,
          textStyle: textStyle,
          shrunkSize: shrunkSize,
          enlargedSize: enlargedSize,
          viewState: direction == HeroFlightDirection.push ? ViewState.enlarge : ViewState.shrink,
          isOverflow: true,
        );
      },
    );
  }
}

class HeroTextPushed extends StatelessWidget {
  final String text;
  final String tag;
  final TextStyle textStyle;
  final double shrunkSize;
  final double enlargedSize;

  const HeroTextPushed({
    Key key,
    @required this.text,
    @required this.tag,
    @required this.textStyle,
    @required this.shrunkSize,
    @required this.enlargedSize,
  })  : assert(text != null),
        assert(tag != null),
        assert(textStyle != null),
        assert(shrunkSize != null),
        assert(enlargedSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: _HeroText(
        text: text,
        textStyle: textStyle,
        shrunkSize: shrunkSize,
        enlargedSize: enlargedSize,
        viewState: ViewState.enlarged,
      ),
    );
  }
}

class _HeroText extends StatefulWidget {
  final String text;
  final ViewState viewState;
  final TextStyle textStyle;
  final double shrunkSize;
  final double enlargedSize;
  final bool isOverflow;
  final Duration duration;

  const _HeroText({
    Key key,
    @required this.text,
    @required this.viewState,
    @required this.textStyle,
    @required this.shrunkSize,
    @required this.enlargedSize,
    this.isOverflow = false,
    this.duration = const Duration(milliseconds: 300),
  })  : assert(text != null),
        assert(viewState != null),
        assert(textStyle != null),
        assert(shrunkSize != null),
        assert(enlargedSize != null),
        super(key: key);

  @override
  _HeroTextState createState() => _HeroTextState();
}

class _HeroTextState extends State<_HeroText> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> sizeTween;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration);

    double sizeBegin, sizeEnd;

    switch (widget.viewState) {
      case ViewState.enlarge:
        sizeBegin = widget.shrunkSize;
        sizeEnd = widget.enlargedSize;
        break;
      case ViewState.enlarged:
        sizeBegin = widget.enlargedSize;
        sizeEnd = widget.enlargedSize;
        break;
      case ViewState.shrink:
        sizeBegin = widget.enlargedSize;
        sizeEnd = widget.shrunkSize;
        break;
      case ViewState.shrunk:
        sizeBegin = widget.shrunkSize;
        sizeEnd = widget.shrunkSize;
        break;
    }

    sizeTween = Tween<double>(
      begin: sizeBegin,
      end: sizeEnd,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Text(
        widget.text,
        style: widget.textStyle.copyWith(fontSize: sizeTween.value),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: widget.isOverflow
          ? OverflowBox(
              alignment: Alignment.center,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: child,
            )
          : child,
    );
  }
}
