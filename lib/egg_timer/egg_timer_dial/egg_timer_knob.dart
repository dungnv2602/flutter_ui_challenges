import 'dart:math';

import 'package:flutter/material.dart';

import '../egg_timer.dart';

const eggTimerGradientColors = [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];

class EggTimerKnob extends StatefulWidget {
  final CountdownTimer timer;

  const EggTimerKnob({
    Key key,
    @required this.timer,
  })  : assert(timer != null),
        super(key: key);

  @override
  _EggTimerKnobState createState() => _EggTimerKnobState();
}

class _EggTimerKnobState extends State<EggTimerKnob> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> snapAnimation;

  CountdownTimerState prevEggTimerState;
  double prevRotationPercent = 0;

  double _currentRotationPercent() => widget.timer.currentTime.inSeconds / widget.timer.maxTime.inSeconds;

  void _triggerAnimation() {
    /// only applies in reset state
    if (widget.timer.currentTime.inSeconds == 0 && prevEggTimerState != CountdownTimerState.ready) {
      snapAnimation = Tween<double>(begin: prevRotationPercent, end: 0).animate(animationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              snapAnimation = null;
            });
          }
        });
      animationController.duration = Duration(milliseconds: (prevRotationPercent / 4 * 1000).round());
      animationController.forward(from: 0);
    }

    prevEggTimerState = widget.timer.state;
    prevRotationPercent = _currentRotationPercent();
  }

  double _rotationPercent() {
    return snapAnimation == null ? _currentRotationPercent() : snapAnimation.value;
  }

  @override
  Widget build(BuildContext context) {
    _triggerAnimation();

    return Stack(
      children: <Widget>[
        /// dial arrow
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: _ArrowPainter(
              rotationPercent: _rotationPercent(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: eggTimerGradientColors,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x44000000),
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFDFDFDF),
                  width: 1.5,
                )),
            child: Center(
              child: Transform(
                // make sure rotation around the center
                alignment: Alignment.center,
                // rotate Z axis by the amount of rotationPercent * 360 degrees
                transform: Matrix4.rotationZ(2 * pi * _rotationPercent()),
                child: FlutterLogo(
                  colors: Colors.blueGrey,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _ArrowPainter extends CustomPainter {
  final double rotationPercent;
  final Paint arrowPaint;

  _ArrowPainter({this.rotationPercent = 0})
      : arrowPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    /// save canvas position
    canvas.save();

    /// translate to top center of the widget
    canvas.translate(radius, radius);

    /// rotate the canvas by the amount of rotationPercent * 360 degrees
    canvas.rotate(2 * pi * rotationPercent);

    /// define the dial arrow =>  the triangle
    final path = Path()
      ..moveTo(0, -radius - 10)
      ..lineTo(-10, -radius + 5)
      ..lineTo(10, -radius + 5)
      ..close();

    /// draw the dial arrow => the triangle
    canvas.drawPath(path, arrowPaint);

    /// draw the shadow beneath the dial arrow
    canvas.drawShadow(path, Colors.black, 3, false);

    /// restore saved canvas position
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_ArrowPainter oldDelegate) => false;
}
