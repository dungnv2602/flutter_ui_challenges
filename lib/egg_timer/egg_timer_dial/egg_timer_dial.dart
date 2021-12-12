/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../egg_timer.dart';
import 'dial_turn_gesture_detector.dart';

class EggTimerDial extends StatelessWidget {
  const EggTimerDial({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CountdownTimer>(
      builder: (_, timer, child) {
        return DialTurnGestureDetector(
          maxTime: timer.maxTime,
          currentTime: timer.currentTime,
          onTimeSelected: timer.onTimeSelected,
          onDialStopTurning: timer.onDialStopTurning,
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 46, right: 46),
              child: AspectRatio(
                // set aspectRatio = 1 to make sure the child always has width = height
                aspectRatio: 1,
                child: Container(
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
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(55),
                        child: CustomPaint(
                          painter: _TickPainter(
                            tickCount: timer.maxTime.inMinutes,
                            tickerPerSection: 5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(64),
                        child: EggTimerKnob(
                          timer: timer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TickPainter extends CustomPainter {
  static const double LONG_TICK = 14;
  static const double SHORT_TICK = 4;

  final int tickCount;
  final int tickerPerSection;
  final double tickInset;

  final Paint tickPaint;

  final TextPainter textPainter;
  final TextStyle textStyle;

  _TickPainter({
    this.tickCount = 35,
    this.tickerPerSection = 5,
    this.tickInset = 0,
  })  : tickPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5,
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'BebasNeue',
        );

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final radius = width / 2; // thanks to aspectRatio = 1 => width = height

    /// translate the canvas to the center of widget
    canvas.translate(radius, radius);

    /// save the current canvas position => the center of widget
    canvas.save();

    for (int i = 0; i < tickCount; ++i) {
      final tickLength = _isLongTick(i) ? LONG_TICK : SHORT_TICK;

      /// draw the tick bottom up from the center
      canvas.drawLine(
        Offset(0, -radius),
        Offset(0, -radius - tickLength),
        tickPaint,
      );

      /// draw the text above the long tick
      if (_isLongTick(i)) {
        /// save the current canvas position => the center of widget
        canvas.save();

        /// translate up by the amount of radius + 30
        canvas.translate(0, -radius - 30);

        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );

        /// layout the text
        textPainter.layout();

        /// figure out which quadrant the text is in
        final tickPercent = i / tickCount;
        final quadrant = _calculateQuadrant(tickPercent);

        /// rotate canvas according to quadrants
        if (quadrant == 4) {
          canvas.rotate(-pi / 2); // rotate -90 degrees
        } else if (quadrant == 3 || quadrant == 2) {
          canvas.rotate(pi / 2); // rotate 90 degrees
        }

        /// paint the text
        textPainter.paint(
          canvas,
          // translate half width & half height of the text
          // so it can staying at the top center of the tick
          Offset(
            -textPainter.width / 2,
            -textPainter.height / 2,
          ),
        );

        /// restore the saved canvas position  => the center of widget
        canvas.restore();
      }

      /// rotate the canvas 360 degrees / tickCount
      canvas.rotate(2 * pi / tickCount);
    }

    /// restore the saved canvas position  => the center of widget
    canvas.restore();
  }

  bool _isLongTick(int i) {
    return i % tickerPerSection == 0;
  }

  /// wiki: https://en.wikipedia.org/wiki/Quadrant_(plane_geometry)
  /// wiki: https://vi.wikipedia.org/wiki/G%C3%B3c_ph%E1%BA%A7n_t%C6%B0
  int _calculateQuadrant(double tickPercent) {
    if (tickPercent < 0.25) return 1;
    if (tickPercent < 0.5) return 4;
    if (tickPercent < 0.75) return 3;
    return 2; // else
  }

  @override
  bool shouldRepaint(_TickPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_TickPainter oldDelegate) => false;
}
