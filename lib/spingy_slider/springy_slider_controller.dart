import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

class SpringySliderController extends ChangeNotifier {
  /// configuration for spring slider simulation
  final _sliderSpringConfig = const SpringDescription(
    mass: 1, // how heavy the spring
    stiffness: 1000, // how quickly the spring contract (the bounce)
    damping: 30, // determine the number of bounces => lower more bouncy
  );

  /// configuration for crest spring simulation
  final _crestSpringConfig = const SpringDescription(
    mass: 1, // how heavy the spring
    stiffness: 5, // how quickly the spring contract (the bounce)
    damping: 0.5, // determine the number of bounces => lower more bouncy
  );

  /// spring physics for slider
  SpringSimulation _sliderSpringSimulation;

  /// when springing to new slider value, this is where the UI is springing from
  double _springStartPercent;

  /// when springing to new slider value, this is where the UI is springing to
  double _springEndPercent;

  /// current slider value during spring effect
  double _springingPercent;

  /// spring physics for slider
  SpringSimulation _crestSpringSimulation;

  /// when springing to new slider value, this is where the UI is springing from
  double _crestSpringStartPercent;

  /// when springing to new slider value, this is where the UI is springing to
  double _crestSpringEndPercent;

  /// current slider value during spring effect
  double _crestSpringingPercent;

  /// existing time + how much time has passed since the start of the spring
  double _springTime;

  /// ticker that computes current spring based on time
  Ticker _springTicker;

  /// stable slider value
  double _sliderPercent;

  /// horizontal slider value during user drag
  double _draggingHorizontalPercent;

  /// vertical slider value during user drag
  double _draggingVerticalPercent;

  final TickerProvider _vsync;

  SpringySliderState _state = SpringySliderState.idle;

  SpringySliderController({
    double sliderPercent = 0,
    @required TickerProvider vsync,
  })  : assert(vsync != null),
        _sliderPercent = sliderPercent,
        _vsync = vsync;

  void onDragStart(double draggingHorizontalPercent) {
    if (_springTicker != null) {
      _springTicker
        ..stop()
        ..dispose();
    }

    _state = SpringySliderState.dragging;
    _draggingVerticalPercent = _sliderPercent;
    _draggingHorizontalPercent = draggingHorizontalPercent;

    notifyListeners();
  }

  void onDragEnd() {
    _state = SpringySliderState.springing;

    _springingPercent = _sliderPercent;
    _springStartPercent = _sliderPercent;
    _springEndPercent = _draggingVerticalPercent.clamp(0.0, 1.0);

    _crestSpringingPercent = draggingVerticalPercent;
    _crestSpringStartPercent = draggingVerticalPercent;
    _crestSpringEndPercent = _springStartPercent;

    _draggingVerticalPercent = null;

    _sliderPercent = _springEndPercent;

    _startSpringing();

    notifyListeners();
  }

  void _startSpringing() {
    if (_springStartPercent == _springEndPercent) {
      _state = SpringySliderState.idle;
      notifyListeners();
      return;
    }

    _sliderSpringSimulation = SpringSimulation(
      _sliderSpringConfig,
      _springStartPercent,
      _springEndPercent,
      0,
    );

    final crestSpringNormal =
        (_crestSpringEndPercent - _crestSpringStartPercent) / (_crestSpringEndPercent - _crestSpringStartPercent).abs();

    _crestSpringSimulation = SpringSimulation(
      _crestSpringConfig,
      _crestSpringStartPercent,
      _crestSpringEndPercent,
      0.5 * crestSpringNormal,
    );

    _springTime = 0.0;

    /// because we create new Ticker every time triggering animation
    /// extends SingleTickerProviderStateMixin will cause error
    /// remember to extends TickerProviderStateMixin
    _springTicker = _vsync.createTicker(_springTick)..start();
  }

  void _springTick(Duration deltaTime) {
    final lastFrameTime = deltaTime.inMilliseconds.toDouble() / 1000;

    _springTime += lastFrameTime;

    /// the spring length after the given amount of time has passed
    _springingPercent = _sliderSpringSimulation.x(_springTime);

    _crestSpringingPercent = _crestSpringSimulation.x(lastFrameTime);

    /// recreate crest spring simulation every single frame based on value of springy simulation
    _crestSpringSimulation = SpringSimulation(
      _crestSpringConfig,
      _crestSpringingPercent,
      _springingPercent,
      _crestSpringSimulation.dx(lastFrameTime),
    );

    if (_sliderSpringSimulation.isDone(_springTime) && _crestSpringSimulation.isDone(lastFrameTime)) {
      _springTicker
        ..stop()
        ..dispose();

      _springTicker = null;

      _state = SpringySliderState.idle;
    }

    notifyListeners();
  }

  SpringySliderState get state => _state;

  double get sliderValue => _sliderPercent;

  double get springingPercent => _springingPercent;

  double get crestSpringingPercent => _crestSpringingPercent;

  double get draggingVerticalPercent => _draggingVerticalPercent;

  set draggingVerticalPercent(double value) {
    _draggingVerticalPercent = value;
    notifyListeners();
  }

  double get draggingHorizontalPercent => _draggingHorizontalPercent;

  set draggingHorizontalPercent(double value) {
    _draggingHorizontalPercent = value;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_springTicker != null) {
      _springTicker.dispose();
    }
    super.dispose();
  }
}

enum SpringySliderState {
  idle,
  dragging,
  springing,
}
