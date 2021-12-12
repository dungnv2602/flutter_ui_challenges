import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final String title;

  const GradientAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBatHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBatHeight),
      height: kToolbarHeight + statusBatHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3366FF),
            Color(0xFF00CCFF),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
