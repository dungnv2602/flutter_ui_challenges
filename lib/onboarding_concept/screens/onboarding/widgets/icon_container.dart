import 'package:flutter/material.dart';

import '../../../constants.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    @required this.icon,
    @required this.padding,
  })  : assert(icon != null),
        assert(padding != null);

  final IconData icon;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 32.0,
        color: kWhite,
      ),
    );
  }
}
