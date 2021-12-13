import 'package:flutter/material.dart';

class SpinnerText extends StatefulWidget {
  const SpinnerText({
    Key key,
    @required this.text,
    this.curveIn = Curves.easeIn,
    this.curveOut = Curves.easeOut,
    this.duration = const Duration(milliseconds: 750),
  })  : assert(text != null),
        super(key: key);

  final Curve curveIn;
  final Curve curveOut;
  final Duration duration;
  final String text;

  @override
  _SpinnerTextState createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText> with SingleTickerProviderStateMixin {
  String bottomText = '';
  AnimationController controller;
  String topText = '';

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      topText = widget.text;
      // need to spin new value
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // assign initial text to bottom text
    bottomText = widget.text;

    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            controller.value = 0.0;
            bottomText = topText;
            topText = '';
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper:
          _RectClipper(), // limit translation to this widget only, prevent translation outside this widget - NICE TRICK
      child: Stack(
        children: <Widget>[
          FractionalTranslation(
            translation: Offset(0, widget.curveIn.transform(controller.value) - 1),
            child: Opacity(
              opacity: widget.curveIn.transform(controller.value),
              child: _Text(text: topText),
            ),
          ),
          FractionalTranslation(
            translation: Offset(0, widget.curveOut.transform(controller.value)),
            child: Opacity(
              opacity: 1 - widget.curveOut.transform(controller.value),
              child: _Text(text: bottomText),
            ),
          ),
        ],
      ),
    );
  }
}

class _RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => this != oldClipper;
}

class _Text extends StatelessWidget {
  const _Text({Key key, @required this.text})
      : assert(text != null),
        super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}
