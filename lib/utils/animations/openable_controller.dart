import 'package:flutter/material.dart';

/// AnimationController wrapper especially designed for open-close widget
class OpenableController extends ChangeNotifier {
  OpenableController({
    @required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 300),
  })  : assert(vsync != null),
        _controller = AnimationController(duration: duration, vsync: vsync) {
    _controller
      ..addListener(() => notifyListeners())
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.dismissed:
            _state = OpenableState.closed;
            break;
          case AnimationStatus.reverse:
            _state = OpenableState.closing;
            break;
          case AnimationStatus.forward:
            _state = OpenableState.opening;
            break;
          case AnimationStatus.completed:
            _state = OpenableState.opened;
            break;
        }
        notifyListeners();
      });
  }

  final AnimationController _controller;

  OpenableState _state = OpenableState.closed;

  void open() => _controller.forward();

  void close() => _controller.reverse();

  void toggle() {
    if (isClosed) {
      open();
    } else if (isOpened) {
      close();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get value => _controller.value;

  OpenableState get state => _state;

  bool get isOpened => _state == OpenableState.opened;

  bool get isOpening => _state == OpenableState.opening;

  bool get isClosed => _state == OpenableState.closed;

  bool get isClosing => _state == OpenableState.closing;
}

enum OpenableState {
  closed,
  opening,
  opened,
  closing,
}
