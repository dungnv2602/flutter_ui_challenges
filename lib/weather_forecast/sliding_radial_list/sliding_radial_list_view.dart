/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';


typedef SlidingRadialListViewBuilder = Widget Function(
    BuildContext context, int index);

class SlidingRadialListView extends StatelessWidget {
  const SlidingRadialListView({
    Key key,
    @required this.controller,
    @required this.builder,
    this.radius = 50.0,
    this.origin = Offset.zero,
  })  : assert(controller != null),
        assert(builder != null),
        super(key: key);

  final SlidingRadialListViewController controller;

  final SlidingRadialListViewBuilder builder;

  final double radius;

  final Offset origin;

  List<Widget> _radialListItems(BuildContext context) {
    final List<Widget> listItems = [];
    for (int index = 0; index < controller.itemCount; index++) {
      listItems.add(
        _radialListItem(
          context,
          index,
          controller.getItemAngle(index),
          controller.getItemOpacity(),
        ),
      );
    }
    return listItems;
  }

  Widget _radialListItem(
      BuildContext context, int index, double angle, double opacity) {
    return Positioned(
      top: origin.dy,
      left: origin.dx,
      child: RadialPosition(
        angle: angle,
        radius: radius,
        child: Opacity(
          opacity: opacity, // this is the one being driven by animation.
          child: builder(context, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          fit: StackFit.expand,
          children: _radialListItems(context),
        );
      },
    );
  }
}

class SlidingRadialListViewController extends ChangeNotifier {
  SlidingRadialListViewController({
    @required TickerProvider vsync,
    @required this.itemCount,
    this.firstItemAngle = -math.pi / 3,
    this.lastItemAngle = math.pi / 3,
    this.startSlidingAngle = 3 / 4 * math.pi,
    this.curve = Curves.easeInOut,
    Duration slideDuration = const Duration(milliseconds: 1500),
    Duration fadeDuration = const Duration(milliseconds: 300),
  })  : assert(vsync != null),
        assert(itemCount != null),
        _slideController =
            AnimationController(duration: slideDuration, vsync: vsync),
        _fadeController =
            AnimationController(duration: fadeDuration, vsync: vsync) {
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
            break;
        }
      });

    _initSlidePositionAnimations();
  }

  static const delayInterval = 0.1;

  /// angle of the first item after animation has done.
  final double firstItemAngle;

  /// angle of the last item after animation has done.
  final double lastItemAngle;

  /// where the items will start animation from.
  final double startSlidingAngle;

  final Curve curve;

  /// number of items need to be animated.
  final int itemCount;

  final AnimationController _fadeController;
  final AnimationController _slideController;
  final List<Animation<double>> _slidePositionAnimations = [];

  RadialListState _state = RadialListState.fadedOut;

  void _initSlidePositionAnimations() {
    final slideInterval = 1 - itemCount / 10;

    final angleDeltaPerItem = (lastItemAngle - firstItemAngle) / itemCount;

    for (int i = 0; i < itemCount; ++i) {
      final endSlidingAngle = firstItemAngle + (angleDeltaPerItem * i);

      final start = delayInterval * i;
      final end = start + slideInterval;

      final tween = Tween(
        begin: startSlidingAngle,
        end: endSlidingAngle,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(start, end, curve: curve),
      ));

      _slidePositionAnimations.add(tween);
    }
  }

  Future<void> open() async {
    if (isFadedOut) {
      await _slideController.forward();
    }
  }

  Future<void> close() async {
    if (isSlidedIn) {
      await _fadeController.forward();
    }
  }

  Future<void> toggle() async {
    if (isFadedOut) {
      await open();
    } else if (isSlidedIn) {
      await close();
    }
  }

  double getItemAngle(int index) {
    return _slidePositionAnimations[index].value;
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

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  double get value => _slideController.value;

  RadialListState get state => _state;

  bool get isSlidedIn => _state == RadialListState.slidedIn;

  bool get isSliding => _state == RadialListState.slidingIn;

  bool get isFadedOut => _state == RadialListState.fadedOut;

  bool get isFading => _state == RadialListState.fadingOut;
}

enum RadialListState {
  fadedOut,
  slidingIn,
  slidedIn,
  fadingOut,
}
