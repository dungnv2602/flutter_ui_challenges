import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenges/utils/utils.dart';

class DialTurnGestureDetector extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime;
  final Widget child;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;
  const DialTurnGestureDetector({
    Key key,
    @required this.currentTime,
    @required this.maxTime,
    @required this.child,
    @required this.onTimeSelected,
    @required this.onDialStopTurning,
  })  : assert(child != null),
        assert(currentTime != null),
        assert(maxTime != null),
        assert(onTimeSelected != null),
        assert(onDialStopTurning != null),
        super(key: key);

  @override
  _DialTurnGestureDetectorState createState() => _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  void _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  void _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      final angleDiff = coord.angle - startDragCoord.angle;
      final angleDiffInPercents = _positiveAngleDiff(angleDiff) / (pi * 2);
      final timeDiffInSeconds = (angleDiffInPercents * widget.maxTime.inSeconds).round();
      selectedTime = Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);
      widget.onTimeSelected(selectedTime);
    }
  }

  double _positiveAngleDiff(double angleDiff) {
    return angleDiff >= 0 ? angleDiff : angleDiff + 2 * pi;
  }

  void _onRadialDragEnd() {
    widget.onDialStopTurning(selectedTime);
    startDragCoord = null;
    startDragTime = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
      child: widget.child,
    );
  }
}
