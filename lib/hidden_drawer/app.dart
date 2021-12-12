import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hidden_menu_controller.dart';
import 'menu_widgets.dart';
import 'screen_recipe.dart';
import 'zoom_scaffold.dart';

// design: https://dribbble.com/shots/2729372-Paleo-Paddock-ios-application-menu-animation

// This implementation is the modified/refactored version originally from Fluttery tutorial.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.bebasNeueTextTheme(),
      ),
      title: 'Material App',
      home: const HiddenMenu(),
    );
  }
}

class HiddenMenu extends StatefulWidget {
  const HiddenMenu({Key key}) : super(key: key);

  @override
  _HiddenMenuState createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<HiddenMenu>
    with SingleTickerProviderStateMixin {
  HiddenMenuController _hiddenMenuController;

  @override
  void initState() {
    super.initState();
    _hiddenMenuController = HiddenMenuController(vsync: this);
  }

  @override
  void dispose() {
    _hiddenMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenMenuProvider(
      controller: _hiddenMenuController,
      child: Builder(
        builder: (_) => Stack(
          children: const [
            MenuScreen(),
            ZoomScaffoldScreen(),
          ],
        ),
      ),
    );
  }
}

class ZoomScaffoldScreen extends StatelessWidget {
  const ZoomScaffoldScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ZoomScaffoldScreen rebuild');

    final hiddenMenu = HiddenMenuProvider.of(context);
    final openable = hiddenMenu.openableController;
    final selectedIndex = hiddenMenu.selectedIndexNotifier;

    return ZoomScaffold(
      openableController: openable,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (_, selectedIndex, __) {
          return ScreenRecipeBuilder(
            recipe: restaurantScreens[selectedIndex],
            onMenuPressed: openable.toggle,
          );
        },
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('MenuScreen rebuild');

    final hiddenMenu = HiddenMenuProvider.of(context);
    final openable = hiddenMenu.openableController;
    final selectedIndex = hiddenMenu.selectedIndexNotifier;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/paddock/dark_grunge_bk.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            MenuTitle(
              animation: openable.animation,
            ),
            HiddenMenuItems(
              controller: openable,
              onItemSelected: (index) {
                selectedIndex.value = index;
                openable.toggle();
              },
              initialSelected: selectedIndex.value,
              models: restaurantScreens
                  .map((screen) => HiddenMenuItemModel(title: screen.title))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
