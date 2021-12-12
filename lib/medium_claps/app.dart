/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// Implementation originated by: https://proandroiddev.com/flutter-animation-creating-mediums-clap-animation-in-flutter-3168f047421e
/// With my own workarounds and improvements
/// Source: https://dribbble.com/shots/4294768-Medium-Claps-Made-in-Flinto
///
import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum ScoreWidgetStatus { HIDDEN, BECOMING_VISIBLE, VISIBLE, BECOMING_INVISIBLE }

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  Timer holdTimer, scoreOutTimer;
  int counter = 0;
  final animationDuration = const Duration(milliseconds: 500);

  ScoreWidgetStatus scoreStatus = ScoreWidgetStatus.HIDDEN;

  AnimationController scoreInController;
  Animation<double> scoreInPosition;
  Animation<double> scoreInOpacity;

  AnimationController scoreOutController;
  Animation<double> scoreOutPosition;
  Animation<double> scoreOutOpacity;

  @override
  void initState() {
    super.initState();

    /// SCORE IN ANIMATION
    scoreInController =
        AnimationController(duration: animationDuration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              scoreStatus = ScoreWidgetStatus.VISIBLE;
            }
          })
          ..addStatusListener((status) {
            print('IN ANIMATION STATUS - $status');
            print('SCORE STATUS - $scoreStatus');
          })
          ..addListener(() {
            setState(() {});
          });
    scoreInPosition = Tween<double>(begin: 0, end: 100).animate(
        CurvedAnimation(parent: scoreInController, curve: Curves.easeOut));
    scoreInOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: scoreInController, curve: Curves.easeOut));

    /// SCORE OUT ANIMATION
    scoreOutController =
        AnimationController(duration: animationDuration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              scoreStatus = ScoreWidgetStatus.HIDDEN;
            }
          })
          ..addStatusListener((status) {
            print('OUT ANIMATION STATUS - $status');
            print('SCORE STATUS - $scoreStatus');
          })
          ..addListener(() {
            setState(() {});
          });
    scoreOutPosition = Tween<double>(begin: 100, end: 200).animate(
        CurvedAnimation(parent: scoreOutController, curve: Curves.easeOut));
    scoreOutOpacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: scoreInController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    scoreInController.dispose();
    scoreOutController.dispose();
    super.dispose();
  }

  void increment(Timer timer) {
    setState(() {
      counter++;
    });
  }

  void fireScoreInAnimation() {
    scoreStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
    scoreInController.forward(from: 0.0);
  }

  void fireScoreOutAnimation() {
    scoreStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    scoreOutController.forward(from: 0.0);
  }

  void onTapDown(TapDownDetails details) {
    /// User pressed the button. This can be a tap or a hold
    /// cancel score out timer if any
    if (scoreOutTimer != null) {
      scoreOutTimer.cancel();
    }
    if (scoreStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      // We tapped down while the widget was flying up. Need to cancel that animation.
      scoreOutController.stop();
      scoreStatus = ScoreWidgetStatus.VISIBLE;
    }
    if (scoreStatus == ScoreWidgetStatus.HIDDEN) {
      /// fire in animation
      fireScoreInAnimation();
    }

    /// Take care of tap
    increment(null);

    /// Take care of hold
    holdTimer = Timer.periodic(animationDuration, increment);
  }

  void onTapUp(TapUpDetails details) {
    /// User removed his finger from button.
    /// cancel on hold timer to stop increment
    holdTimer.cancel();

    /// fire out animation after duration = 300ms (wait for in animation to complete)
    scoreOutTimer = Timer(animationDuration, () {
      fireScoreOutAnimation();
    });
  }

  Widget getScoreButton() {
    double scorePosition = 0.0;
    double scoreOpacity = 0.0;

    switch (scoreStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.VISIBLE:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE:
        scorePosition = scoreInPosition.value;
        scoreOpacity = scoreInOpacity.value;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPosition.value;
        scoreOpacity = scoreOutOpacity.value;
        break;
    }

    return Positioned(
      bottom: scorePosition,
      child: Opacity(
        opacity: scoreOpacity,
        child: Container(
          width: 50,
          height: 50,
          decoration: const ShapeDecoration(
            shape: CircleBorder(side: BorderSide.none),
            color: Colors.pink,
          ),
          child: Center(
            child: Text(
              '+ ${counter.toString()}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget getClapButton() {
    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(width: 1, color: Colors.pink),
          ),
          color: Colors.white,
        ),
        child: ImageIcon(
          AssetImage('assets/images/clap.png'),
          color: Colors.pink,
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: <Widget>[
            getScoreButton(),
            getClapButton(),
          ],
        ),
      ),
    );
  }
}
