/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';

import 'package:flutter/foundation.dart';

class CountdownTimer extends ChangeNotifier {
  final Duration maxTime;
  Duration _lastStartTime = const Duration(seconds: 0);
  Duration _currentTime = const Duration(seconds: 0);

  CountdownTimerState _state = CountdownTimerState.ready;

  final Stopwatch _stopwatch = Stopwatch();

  CountdownTimer({this.maxTime = const Duration(minutes: 35)});

  void resume() {
    if (state != CountdownTimerState.running) {
      if (state == CountdownTimerState.ready) {
        _currentTime = _roundToNearestMinute(_currentTime);
        _lastStartTime = _currentTime;
      }
      _state = CountdownTimerState.running;
      notifyListeners();
      _stopwatch.start();
      _tick();
    }
  }

  void pause() {
    if (state == CountdownTimerState.running) {
      _state = CountdownTimerState.paused;
      notifyListeners();
      _stopwatch.stop();
    }
  }

  void reset() {
    if (state == CountdownTimerState.paused) {
      _state = CountdownTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      _lastStartTime = _currentTime;
      notifyListeners();
      _stopwatch.reset();
    }
  }

  void restart() {
    if (state == CountdownTimerState.paused) {
      _state = CountdownTimerState.running;
      _currentTime = _lastStartTime;
      notifyListeners();
      _stopwatch.reset();
      _stopwatch.start();
      _tick();
    }
  }

  void onTimeSelected(Duration newTime) {
    currentTime = newTime;
  }

  void onDialStopTurning(Duration newTime) {
    currentTime = newTime;
    resume();
  }

  void _tick() {
    _currentTime = _lastStartTime - _stopwatch.elapsed;

    if (_currentTime.inSeconds > 0 && _state == CountdownTimerState.running) {
      Timer(const Duration(seconds: 1), _tick);
    }

    notifyListeners();
  }

  Duration _roundToNearestMinute(Duration duration) {
    return Duration(minutes: (duration.inSeconds / 60).round());
  }

  set currentTime(Duration newTime) {
    if (_state == CountdownTimerState.ready) {
      _currentTime = newTime;
      _lastStartTime = _currentTime;
      notifyListeners();
    }
  }

  Duration get currentTime => _currentTime;

  Duration get lastStartTime => _lastStartTime;

  CountdownTimerState get state => _state;
}

enum CountdownTimerState { ready, running, paused }
