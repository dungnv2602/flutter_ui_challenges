import 'package:flutter/material.dart';

class AirAsiaDot extends StatelessWidget {
  const AirAsiaDot({
    Key key,
    this.animation,
    @required this.color,
  }) : super(key: key);

  final Color color;
  final Animation<double> animation;
  static const size = 24.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Positioned(
        top: animation.value,
        child: child,
      ),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class AirAsiaPlaneIcon extends StatelessWidget {
  const AirAsiaPlaneIcon({Key key, this.animation}) : super(key: key);
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Icon(
        Icons.airplanemode_active,
        color: Colors.red,
        size: animation.value,
      ),
    );
  }
}

class AirAsiaFlightStop {
  const AirAsiaFlightStop(this.from, this.to, this.date, this.duration, this.price, this.fromToTime);
  final String from;
  final String to;
  final String date;
  final String duration;
  final String price;
  final String fromToTime;
}

