import 'package:flutter/material.dart';

class PlanetCardSeparator extends StatelessWidget {
  const PlanetCardSeparator();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 2.0,
      width: 18.0,
      color: const Color(0xff00c6ff),
    );
  }
}
