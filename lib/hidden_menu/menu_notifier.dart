import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

// TODO(joe): LOGO on header
// TODO(joe): use AnimatedModalBarrier to cover Page when menu is opened
// TODO(joe): refactor to restrict 1-2 listeners to improve performance
// TODO(joe): supprt drag back gesture to close menu
class MenuNotifier extends ChangeNotifier {
  MenuNotifier({
    @required TickerProvider vsync,
    this.menuDuration = MotionDurations.d650,
    this.indicatorDuration = const Duration(milliseconds: 300),
    int selectedIndex = 0,
    bool isSignedIn,
  })  : _items = _getItems(isSignedIn: isSignedIn),
        _isSignedIn = isSignedIn,
        _selectedIndex = selectedIndex,
        _prevSelectedIndex = selectedIndex,
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
          if (_menuController.status.isForward &&
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
          if (status.isForward) {
            _indicatorSelectorState = IndicatorSwitchingState.switching;
            notifyListeners();
          } else if (status.isCompleted) {
            _indicatorSelectorState = IndicatorSwitchingState.idle;
            notifyListeners();
            // trigger indicator moving down
            if (!_haltToggle) {
              toggle();
            } else {
              // reset halt toggle
              _haltToggle = false;
            }
          }
        },
      );
  }

  final Duration menuDuration;
  final Duration indicatorDuration;

  final AnimationController _menuController;
  final AnimationController _indicatorController;
  final AnimationController _indicatorSwitchingController;
  Animation<double> indicatorSwitchingAnimation;

  MenuState _menuState = MenuState.closed;
  IndicatorState _indicatorState = IndicatorState.deepDown;
  IndicatorSwitchingState _indicatorSelectorState =
      IndicatorSwitchingState.idle;

  double _indicatorHeight = 0;

  int _prevSelectedIndex;
  int _selectedIndex;

  bool _isSignedIn;
  bool _haltToggle = false;

  List<MenuViewItem> _items;

  void onMenuItemSelected(int index) {
    _prevSelectedIndex = _selectedIndex;
    _selectedIndex = index;
    _driveSwitchingAnimation();
  }

  void _driveSwitchingAnimation() {
    // reset tween
    indicatorSwitchingAnimation = Tween<double>(
      begin: 0.0 + _prevSelectedIndex,
      end: 0.0 + _selectedIndex,
    ).animate(_indicatorSwitchingController);
    // reset duration
    _indicatorSwitchingController.duration = Duration(
      milliseconds: lerpDouble(
        150,
        300,
        (_selectedIndex - _prevSelectedIndex).abs() / (_items.length - 1),
      ).round(),
    );
    _indicatorSwitchingController.forward(from: 0);
  }

  // TODO(joe): disable/enable LogoAppBar when open/close menu
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

  void setSignedIn({bool isSignedIn}) {
    _isSignedIn = isSignedIn;
    // get prev selectedIndex before list changes
    _prevSelectedIndex = _selectedIndex;
    // get prev selectedItem before list changes
    final prevSelectedItem = _items[_prevSelectedIndex];
    // re-assign list when signin change
    _items = _getItems(isSignedIn: _isSignedIn);
    // restore selectedIndex to prev selectedItem
    _selectedIndex = _items
        .indexWhere((item) => item.menuTitle == prevSelectedItem.menuTitle);
    // if item not found => set index to 0
    if (_selectedIndex == -1) _selectedIndex = 0;
    // signal halt toggle
    _haltToggle = true;
    // trigger indicator animation
    _driveSwitchingAnimation();
  }

  void setIndicatorHeight(double height) {
    if (_indicatorHeight != height) {
      _indicatorHeight = height;
      notifyListeners();
    }
  }

  bool get isSignedIn => _isSignedIn;

  double get indicatorHeight => _indicatorHeight;

  int get selectedIndex => _selectedIndex;

  MenuViewItem get selectedItem => _items[_selectedIndex];

  List<MenuViewItem> get items => _items;

  double get menuProgress => _menuController?.value ?? 0.0;

  double get indicatorProgress => _indicatorController?.value ?? 0.0;

  double get indicatorSwitchingAnimationProgess =>
      indicatorSwitchingAnimation?.value ?? 0.0;

  Animation<double> get menuAnimation => _menuController;

  bool get isMenuClosed => _menuState == MenuState.closed;

  @override
  void dispose() {
    _menuController?.dispose();
    _indicatorController?.dispose();
    super.dispose();
  }
}

enum MenuState { closed, closing, opening, opened }
enum IndicatorState { deepDown, movingUp, standStill, movingDown }
enum IndicatorSwitchingState { idle, switching }

class MenuViewItem {
  MenuViewItem({
    @required this.menuIcon,
    @required this.menuTitle,
    @required this.child,
    this.hasMenuIcon = true,
  }) : assert(menuIcon != null && menuTitle != null && child != null);

  final Widget child;
  final IconData menuIcon;
  final String menuTitle;
  final bool hasMenuIcon;
}

List<MenuViewItem> _getItems({bool isSignedIn}) {
  return [
    MenuViewItem(
      menuIcon: Icons.ac_unit,
      menuTitle: 'Home',
      // child: const MediaHomePage(),
      hasMenuIcon: false,
    ),
    if (isSignedIn)
      MenuViewItem(
        menuIcon: Icons.ac_unit,
        menuTitle: 'Profile',
        // child: const UserProfilePage(),
      ),
    if (isSignedIn)
      MenuViewItem(
        menuIcon: Icons.ac_unit,
        menuTitle: 'Collections',
        // child: const UserCollectionsPage(),
      ),
    MenuViewItem(
      menuIcon: Icons.ac_unit,
      menuTitle: 'Settings',
      // child: const SettingsPage(),
    ),
    MenuViewItem(
      menuIcon: Icons.ac_unit,
      menuTitle: 'About',
      // child: const AboutPage(),
    ),
  ];
}
