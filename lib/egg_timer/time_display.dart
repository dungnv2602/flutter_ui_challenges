/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'egg_timer.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({Key key}) : super(key: key);

  @override
  _TimeDisplayState createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay>
    with SingleTickerProviderStateMixin {
  final DateFormat _selectionTimeFormat = DateFormat('mm');
  final DateFormat _countdownTimeFormat = DateFormat('mm:ss');

  AnimationController _animationController;

  String _formattedSelectionTime(CountdownTimer timer) {
    final dateTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, timer.lastStartTime.inSeconds);
    return _selectionTimeFormat.format(dateTime);
  }

  String _formattedCountdownTime(CountdownTimer timer) {
    final dateTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, timer.currentTime.inSeconds);
    return _countdownTimeFormat.format(dateTime);
  }

  void _triggerAnimation(CountdownTimer timer) {
    if (timer.state == CountdownTimerState.ready) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountdownTimer>(
      builder: (_, timer, ___) {
        _triggerAnimation(timer);

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(
                  0,
                  -200.0 * (1 - _animationController.value),
                  0,
                ),
                child: Text(
                  _formattedSelectionTime(timer),
                  textAlign: TextAlign.center,
                  style: _textStyle,
                ),
              ),
              Opacity(
                opacity: 1 - _animationController.value,
                child: Text(
                  _formattedCountdownTime(timer),
                  textAlign: TextAlign.center,
                  style: _textStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    /// avoid initial animation
    _animationController.value = 1;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

const _textStyle = TextStyle(
  color: Colors.black,
  fontSize: 150,
  fontWeight: FontWeight.bold,
  letterSpacing: 10,
);
