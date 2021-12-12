import 'package:flutter/material.dart';

const menuModels = <MenuModel>[
  MenuModel(
    title: 'Home',
    icon: Icons.home,
    color: Colors.brown,
  ),
  MenuModel(
    title: 'Business',
    icon: Icons.business,
    color: Colors.amber,
  ),
  MenuModel(
    title: 'School',
    icon: Icons.school,
    color: Colors.teal,
  ),
  MenuModel(
    title: 'Flight',
    icon: Icons.flight,
    color: Colors.cyan,
  ),
  MenuModel(
    title: 'Profile',
    icon: Icons.person,
    color: Colors.blue,
  ),
  MenuModel(
    title: 'Settings',
    icon: Icons.settings,
    color: Colors.grey,
  ),
];

final menuViewModels = <MenuViewModel>[
  MenuViewModel(
    index: 0,
    menu: menuModels[0],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/home',
      child: TestPage(
        model: menuModels[0],
      ),
    ),
  ),
  MenuViewModel(
    index: 1,
    menu: menuModels[1],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/business',
      child: TestPage(
        model: menuModels[1],
      ),
    ),
  ),
  MenuViewModel(
    index: 2,
    menu: menuModels[2],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/school',
      child: TestPage(
        model: menuModels[2],
      ),
    ),
  ),
  MenuViewModel(
    index: 3,
    menu: menuModels[3],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/flight',
      child: TestPage(
        model: menuModels[3],
      ),
    ),
  ),
  MenuViewModel(
    index: 4,
    menu: menuModels[4],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/profile',
      child: TestPage(
        model: menuModels[4],
      ),
    ),
  ),
  MenuViewModel(
    index: 5,
    menu: menuModels[5],
    view: ViewModel(
      stateKey: GlobalKey(),
      navigatorKey: GlobalKey<NavigatorState>(),
      route: '/settings',
      child: TestPage(
        model: menuModels[5],
      ),
    ),
  ),
];

class TestPage extends StatefulWidget {
  const TestPage({Key key, @required this.model}) : super(key: key);

  final MenuModel model;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.title),
        backgroundColor: widget.model.color,
      ),
      body: Center(child: Text('$_counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter += 1),
      ),
    );
  }
}

class MenuViewModel {
  const MenuViewModel({
    @required this.index,
    @required this.menu,
    @required this.view,
  });
  final int index;
  final MenuModel menu;
  final ViewModel view;
}

class ViewModel {
  const ViewModel({
    @required this.child,
    @required this.route,
    @required this.stateKey,
    @required this.navigatorKey,
  });

  final Widget child;
  final String route;
  final GlobalKey stateKey;
  final GlobalKey<NavigatorState> navigatorKey;
}

class MenuModel {
  const MenuModel({
    @required this.title,
    @required this.icon,
    this.color,
  });

  final String title;
  final IconData icon;
  final MaterialColor color;
}
