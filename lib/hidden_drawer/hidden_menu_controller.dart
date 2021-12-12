import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

class HiddenMenuProvider extends InheritedWidget {
  const HiddenMenuProvider({
    Key key,
    @required Widget child,
    @required this.controller,
  }) : super(
          child: child,
          key: key,
        );

  final HiddenMenuController controller;

  static HiddenMenuController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<HiddenMenuProvider>()
      .controller;

  @override
  bool updateShouldNotify(HiddenMenuProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}

class HiddenMenuController {
  HiddenMenuController({
    @required TickerProvider vsync,
    Duration duration,
    int initialIndex,
  })  : openableController =
            OpenableController(vsync: vsync, duration: duration),
        selectedIndexNotifier =
            SelectedIndexNotifier(initialIndex: initialIndex);

  final OpenableController openableController;

  final SelectedIndexNotifier selectedIndexNotifier;

  void dispose() {
    openableController.dispose();
    selectedIndexNotifier.dispose();
  }
}

class SelectedIndexNotifier extends ValueNotifier<int> {
  SelectedIndexNotifier({int initialIndex}) : super(initialIndex ?? 0);
}
