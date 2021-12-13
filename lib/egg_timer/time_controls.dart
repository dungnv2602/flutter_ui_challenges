import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'egg_timer.dart';

class TimeControls extends StatefulWidget {
  const TimeControls({Key key}) : super(key: key);

  @override
  _TimeControlsState createState() => _TimeControlsState();
}

class _TimeControlsState extends State<TimeControls> with TickerProviderStateMixin {
  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  void _triggerAnimation(CountdownTimer timer) {
    switch (timer.state) {
      case CountdownTimerState.ready:
        pauseResumeSlideController.forward();
        restartResetFadeController.forward();
        break;
      case CountdownTimerState.running:
        pauseResumeSlideController.reverse();
        restartResetFadeController.forward();
        break;
      case CountdownTimerState.paused:
        pauseResumeSlideController.reverse();
        restartResetFadeController.reverse();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountdownTimer>(
      builder: (_, timer, child) {
        _triggerAnimation(timer);

        return Column(
          children: <Widget>[
            Opacity(
              opacity: 1 - restartResetFadeController.value,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: TimeButton(
                      icon: Icons.refresh,
                      text: 'RESTART',
                      onPressed: timer.restart,
                    ),
                  ),
                  Expanded(
                    child: TimeButton(
                      icon: Icons.arrow_back,
                      text: 'RESET',
                      onPressed: timer.reset,
                    ),
                  ),
                ],
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0,
                100 * pauseResumeSlideController.value,
                0,
              ),
              child: TimeButton(
                icon: timer.state == CountdownTimerState.running ? Icons.pause : Icons.play_arrow,
                text: timer.state == CountdownTimerState.running ? 'PAUSE' : 'RESUME',
                onPressed: timer.state == CountdownTimerState.running ? timer.pause : timer.resume,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    pauseResumeSlideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    restartResetFadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    pauseResumeSlideController.value = 1;
    restartResetFadeController.value = 1;
  }

  @override
  void dispose() {
    pauseResumeSlideController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }
}
