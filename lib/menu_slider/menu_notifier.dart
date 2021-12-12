import 'dart:ui';

import 'package:flutter/widgets.dart';

enum MenuState { closed, closing, opening, opened }
enum IndicatorState { deepDown, movingUp, standStill, movingDown }
enum IndicatorSwitchingState { idle, switching }

class MenuViewItem {
  final Widget menuIcon;
  final String menuTitle;
  final Widget child;

  MenuViewItem({
    @required this.menuIcon,
    @required this.menuTitle,
    @required this.child,
  }) : assert(menuIcon != null && menuTitle != null && child != null);
}

class MenuNotifier extends ChangeNotifier {
  MenuState _menuState = MenuState.closed;
  IndicatorState _indicatorState = IndicatorState.deepDown;
  IndicatorSwitchingState _indicatorSelectorState =
      IndicatorSwitchingState.idle;

  int selectedIndex;
  int prevSelectedIndex;
  double indicatorHeight = 0;

  final List<MenuViewItem> items;

  final TickerProvider vsync;

  final Duration menuDuration;
  final Duration indicatorDuration;

  final AnimationController _menuController;
  final AnimationController _indicatorController;
  final AnimationController _indicatorSwitchingController;

  Animation<double> indicatorSwitchingAnimation;

  MenuNotifier({
    this.selectedIndex = 0,
    @required this.items,
    @required this.vsync,
    this.menuDuration = const Duration(milliseconds: 750),
    this.indicatorDuration = const Duration(milliseconds: 300),
  })  : prevSelectedIndex = selectedIndex,
        _menuController =
            AnimationController(vsync: vsync, duration: menuDuration),
        _indicatorController =
            AnimationController(vsync: vsync, duration: indicatorDuration),
        _indicatorSwitchingController = AnimationController(vsync: vsync) {
    _menuController
      ..addListener(notifyListeners)
      ..addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.dismissed:
              _menuState = MenuState.closed;
              notifyListeners();
              break;
            case AnimationStatus.reverse:
              _menuState = MenuState.closing;
              notifyListeners();
              break;
            case AnimationStatus.forward:
              _menuState = MenuState.opening;
              notifyListeners();
              break;
            case AnimationStatus.completed:
              _menuState = MenuState.opened;
              notifyListeners();
              break;
          }
        },
      )
      ..addListener(
        () {
          // trigger indicator at 50% menu forward
          if (_menuController.status == AnimationStatus.forward &&
              _menuController.value >= 0.5 &&
              _indicatorState == IndicatorState.deepDown)
            _indicatorController.forward();
        },
      );
    _indicatorController
      ..addListener(notifyListeners)
      ..addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.forward:
              _indicatorState = IndicatorState.movingUp;
              notifyListeners();
              break;
            case AnimationStatus.reverse:
              _indicatorState = IndicatorState.movingDown;
              notifyListeners();
              break;
            case AnimationStatus.completed:
              _indicatorState = IndicatorState.standStill;
              notifyListeners();
              break;
            case AnimationStatus.dismissed:
              _indicatorState = IndicatorState.deepDown;
              notifyListeners();
              break;
          }
        },
      );
    _indicatorSwitchingController
      ..addListener(notifyListeners)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.forward) {
            _indicatorSelectorState = IndicatorSwitchingState.switching;
            notifyListeners();
          } else if (status == AnimationStatus.completed) {
            _indicatorSelectorState = IndicatorSwitchingState.idle;
            notifyListeners();
            // trigger indicator moving down
            toggle();
          }
        },
      );
  }

  void onMenuItemSelected(int index) {
    prevSelectedIndex = selectedIndex;
    selectedIndex = index;
    // reset tween
    indicatorSwitchingAnimation = Tween<double>(
      begin: prevSelectedIndex.toDouble(),
      end: selectedIndex.toDouble(),
    ).animate(_indicatorSwitchingController);
    // reset duration
    _indicatorSwitchingController.duration = Duration(
      milliseconds: lerpDouble(
        150,
        300,
        (selectedIndex - prevSelectedIndex).abs() / (items.length - 1),
      ).round(),
    );
    _indicatorSwitchingController.forward(from: 0);
  }

  void setIndicatorHeight(double height) {
    if (indicatorHeight != height) {
      indicatorHeight = height;
      notifyListeners();
    }
  }

  void toggle() {
    if (_menuState == MenuState.opened &&
        _indicatorState == IndicatorState.standStill) {
      _indicatorController.reverse();
      _menuController.reverse();
    } else if (_menuState == MenuState.closed &&
        _indicatorState == IndicatorState.deepDown) {
      _menuController.forward();
    }
  }

  MenuViewItem get selectedItem => items[selectedIndex];

  double get menuProgress => _menuController?.value ?? 0.0;

  double get indicatorProgress => _indicatorController?.value ?? 0.0;

  double get indicatorSwitchingAnimationProgess =>
      indicatorSwitchingAnimation?.value ?? 0.0;

  Animation<double> get menuAnimation => _menuController;

  IndicatorState get indicatorState => _indicatorState;

  IndicatorSwitchingState get indicatorSelectorState => _indicatorSelectorState;

  bool get isMenuOpened => _menuState == MenuState.opened;

  bool get isMenuOpening => _menuState == MenuState.opening;

  bool get isMenuClosed => _menuState == MenuState.closed;

  bool get isMenuClosing => _menuState == MenuState.closing;

  @override
  void dispose() {
    _menuController?.dispose();
    _indicatorController?.dispose();
    super.dispose();
  }
}
