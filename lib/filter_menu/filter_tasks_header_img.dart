import 'package:flutter/material.dart';

class FilterTasksHeaderImg extends StatelessWidget {
  const FilterTasksHeaderImg({
    Key key,
    @required this.height,
    @required this.diagonalHeight,
  }) : super(key: key);
  final double height;
  final double diagonalHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: ClipPath(
        clipper: _DiagonalClipper(diagonalHeight),
        child: Image.asset(
          'assets/images/filter_menu/birds.jpg',
          height: height,
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.srcOver,
          color: const Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  _DiagonalClipper(this.cut) : path = Path();

  final double cut;
  final Path path;

  @override
  Path getClip(Size size) {
    path
      ..lineTo(0, size.height - cut)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_DiagonalClipper oldClipper) => false;
}
