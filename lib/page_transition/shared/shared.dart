import 'package:flutter/material.dart';
export 'header.dart';
export 'title.dart';
export 'details.dart';

const animationDuration = Duration(milliseconds: 800);

enum ViewState {
  enlarge,
  enlarged,
  shrink,
  shrunk,
}

class BeveledRectangleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final Color iconColor;
  final Color buttonColor;
  final double buttonSize;

  const BeveledRectangleButton({
    Key key,
    @required this.onPressed,
    @required this.iconData,
    this.iconColor = Colors.white,
    this.buttonColor = Colors.black,
    this.buttonSize = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: FlatButton(
        shape: BeveledRectangleBorder(),
        splashColor: Colors.white24,
        color: buttonColor,
        child: Icon(iconData, color: iconColor, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
