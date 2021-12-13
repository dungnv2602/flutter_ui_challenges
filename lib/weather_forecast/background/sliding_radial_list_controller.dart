import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SlidingRadialListController extends ChangeNotifier {
  SlidingRadialListController({
    @required TickerProvider vsync,
    Duration slideDuration = const Duration(milliseconds: 1500),
    Duration fadeDuration = const Duration(milliseconds: 300),
    @required this.itemCount,
  })  : assert(vsync != null),
        assert(itemCount != null),
        _slideController = AnimationController(duration: slideDuration, vsync: vsync),
        _fadeController = AnimationController(duration: fadeDuration, vsync: vsync) {
    _slideController
      ..addListener(notifyListeners)
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
          case AnimationStatus.forward:
            _state = RadialListState.slidingIn;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.slidedIn;
            notifyListeners();
            onSlidedInCompleter.complete();
            break;
        }
      });

    _fadeController
      ..addListener(notifyListeners)
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
          case AnimationStatus.forward:
            _state = RadialListState.fadingOut;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.fadedOut;
            // reset
            _slideController.value = 0.0;
            _fadeController.value = 0.0;
            notifyListeners();
            onFadedOutCompleter.complete();
            break;
        }
      });

    const double delayInterval = 0.1;
    const double slideInterval = 0.5;
    final angleDeltaPerItem = (lastItemAngle - firstItemAngle) / itemCount;

    for (int i = 0; i < itemCount; ++i) {
      final endSlidingAngle = firstItemAngle + (angleDeltaPerItem * i);

      final start = delayInterval * i;
      final end = start + slideInterval;

      _slidePositions.add(
        Tween(
          begin: startSlidingAngle,
          end: endSlidingAngle,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        )),
      );
    }
  }

  final firstItemAngle = -pi / 3;
  final lastItemAngle = pi / 2;
  final startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final AnimationController _slideController;
  final AnimationController _fadeController;
  final List<Animation<double>> _slidePositions = [];

  Completer<dynamic> onSlidedInCompleter;
  Completer<dynamic> onFadedOutCompleter;

  RadialListState _state = RadialListState.fadedOut;

  Future<dynamic> open() {
    if (isFadedOut) {
      _slideController.forward();
      onSlidedInCompleter = Completer<dynamic>();
      return onSlidedInCompleter.future;
    }
    return null;
  }

  Future<dynamic> close() {
    if (isSlidedIn) {
      _fadeController.forward();
      onFadedOutCompleter = Completer<dynamic>();
      return onFadedOutCompleter.future;
    }
    return null;
  }

  void toggle() {
    if (isFadedOut) {
      open();
    } else if (isSlidedIn) {
      close();
    }
  }

  double getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  double getItemOpacity() {
    switch (_state) {
      case RadialListState.fadedOut:
        return 0;
      case RadialListState.fadingOut:
        return 1 - _fadeController.value;
      case RadialListState.slidingIn:
      case RadialListState.slidedIn:
      default:
        return 1;
    }
  }

  double get value => _slideController.value;

  RadialListState get state => _state;

  bool get isSlidedIn => _state == RadialListState.slidedIn;

  bool get isSliding => _state == RadialListState.slidingIn;

  bool get isFadedOut => _state == RadialListState.fadedOut;

  bool get isFading => _state == RadialListState.fadingOut;

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

enum RadialListState {
  fadedOut,
  slidingIn,
  slidedIn,
  fadingOut,
}
