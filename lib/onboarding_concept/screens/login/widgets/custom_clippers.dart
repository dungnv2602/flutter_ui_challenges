import 'package:flutter/material.dart';

class WhiteContainerClipper extends CustomClipper<Path> {
  WhiteContainerClipper({
    @required this.yOffset,
  })  : assert(yOffset != null),
        _path = Path();

  final double yOffset;
  final Path _path;

  @override
  Path getClip(Size size) {
    _path
      ..lineTo(0.0, 220.0 + yOffset)
      ..quadraticBezierTo(
        size.width / 2.2,
        260.0 + yOffset,
        size.width,
        170.0 + yOffset,
      )
      ..lineTo(size.width, 0.0)
      ..close();
    return _path;
  }

  @override
  bool shouldReclip(WhiteContainerClipper oldClipper) => yOffset != oldClipper.yOffset;
}

class BlueContainerClipper extends CustomClipper<Path> {
  BlueContainerClipper({
    @required this.yOffset,
  })  : assert(yOffset != null),
        _path = Path();

  final double yOffset;
  final Path _path;

  @override
  Path getClip(Size size) {
    _path
      ..lineTo(0.0, 265.0 + yOffset)
      ..quadraticBezierTo(
        size.width / 2,
        285.0 + yOffset,
        size.width,
        185.0 + yOffset,
      )
      ..lineTo(size.width, 0.0)
      ..close();
    return _path;
  }

  @override
  bool shouldReclip(BlueContainerClipper oldClipper) => yOffset != oldClipper.yOffset;
}

class GreyContainerClipper extends CustomClipper<Path> {
  GreyContainerClipper({
    @required this.yOffset,
  })  : assert(yOffset != null),
        _path = Path();

  final double yOffset;
  final Path _path;

  @override
  Path getClip(Size size) {
    _path
      ..lineTo(0.0, 310.0 + yOffset)
      ..quadraticBezierTo(
        size.width / 2,
        310.0 + yOffset,
        size.width,
        200.0 + yOffset,
      )
      ..lineTo(size.width, 0.0)
      ..close();
    return _path;
  }

  @override
  bool shouldReclip(GreyContainerClipper oldClipper) => yOffset != oldClipper.yOffset;
}
