import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:provider/provider.dart';

import 'menu_notifier.dart';
import 'menu_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Slider',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuNotifier>(
      create: (context) => MenuNotifier(
        vsync: this,
        items: [
          MenuViewItem(
            menuIcon: Icon(Icons.ac_unit),
            menuTitle: 'Home',
            child: Page1(),
          ),
          MenuViewItem(
            menuIcon: Icon(Icons.access_time),
            menuTitle: 'Profile',
            child: Page2(),
          ),
          MenuViewItem(
            menuIcon: Icon(Icons.account_box),
            menuTitle: 'Settings',
            child: Page3(),
          ),
          MenuViewItem(
            menuIcon: Icon(Icons.account_box),
            menuTitle: 'Settings1',
            child: Page3(),
          ),
          MenuViewItem(
            menuIcon: Icon(Icons.account_box),
            menuTitle: 'Settings2',
            child: Page3(),
          ),
          MenuViewItem(
            menuIcon: Icon(Icons.account_box),
            menuTitle: 'Settings3',
            child: Page3(),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Menu
            const MenuView(),
            // Pages
            const SlideAndScaleView(),
          ],
        ),
      ),
    );
  }
}

class SlideAndScaleView extends StatelessWidget {
  static const curve = Curves.fastLinearToSlowEaseIn;

  const SlideAndScaleView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<MenuNotifier>(
      builder: (_, notifier, __) {
        final value = curve.transform(notifier.menuProgress);
        final selectedItem = notifier.selectedItem;
        return Transform(
          transform: Matrix4.identity()
            ..translate(size.width * 0.7 * value, size.height * 0.15 * value)
            ..scale(1 - (0.3 * value)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16 * value),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2 * value, 2 * value),
                  spreadRadius: 2 * value,
                  blurRadius: 16 * value,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16 * value),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: AnimatedSpinner(
                    child: Text(notifier.selectedItem.menuTitle),
                    configuration: AnimatedSpinnerConfiguration(
                      duration: notifier.menuDuration,
                    ),
                  ),
                  leading: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_arrow,
                      progress: notifier.menuAnimation,
                    ),
                    onPressed: notifier.toggle,
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    AnimatedSwitcher(
                      switchInCurve: curve,
                      switchOutCurve: curve,
                      duration: notifier.menuDuration,
                      child: selectedItem.child,
                    ),
                    // add a layer to prevent tapping
                    if (!notifier.isMenuClosed)
                      Container(
                        color: Colors.transparent,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Center(
          child: RaisedButton(
            onPressed: () {},
            child: Text(notifier.selectedItem.menuTitle),
          ),
        );
      },
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Center(
          child: RaisedButton(
            onPressed: () {},
            child: Text(notifier.selectedItem.menuTitle),
          ),
        );
      },
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Center(
          child: RaisedButton(
            onPressed: () {},
            child: Text(notifier.selectedItem.menuTitle),
          ),
        );
      },
    );
  }
}
