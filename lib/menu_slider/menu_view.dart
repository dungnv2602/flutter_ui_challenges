import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_notifier.dart';

const _interval = Interval(0.5, 1.0, curve: Curves.fastOutSlowIn);

class MenuView extends StatelessWidget {
  const MenuView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BackgroundLogo(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserInfo(),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    AnimatedMenuItems(),
                    AnimatedIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackgroundLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        final width = MediaQuery.of(context).size.width;
        return Positioned(
          left: 1.5 * width -
              1.65 * width * _interval.transform(notifier.menuProgress),
          child: Text(
            'TMDb',
            style: TextStyle(
              color: Colors.black12,
              fontSize: 240,
              fontWeight: FontWeight.bold,
              letterSpacing: 20,
              height: 1.1,
            ),
            softWrap: false,
          ),
        );
      },
    );
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: _interval.transform(notifier.menuProgress),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 16, top: 128),
            child: Column(
              children: <Widget>[
                Text(
                  'Guest',
                  style: Theme.of(context).textTheme.headline,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'guest',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final curve = Curves.fastLinearToSlowEaseIn;
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        final gap = notifier.indicatorHeight *
            notifier.indicatorSwitchingAnimationProgess;
        final heightGap =
            size.height * curve.transform(notifier.indicatorProgress) - gap;
        final top = size.height - heightGap;
        return Positioned(
          top: top,
          child: Opacity(
            opacity: curve.transform(notifier.indicatorProgress),
            child: SizedBox(
              width: size.width,
              height: notifier.indicatorHeight,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 5,
                    color: Colors.black54,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedMenuItems extends StatelessWidget {
  List<Widget> buildMenuItems(MenuNotifier notifier) {
    final menuItems = <MenuItem>[];
    for (var index = 0; index < notifier.items.length; index++) {
      final item = notifier.items[index];
      menuItems.add(
        MenuItem(
          icon: item.menuIcon,
          title: item.menuTitle,
          isSelected: notifier.selectedIndex == index,
          onTap: () => notifier.onMenuItemSelected(index),
        ),
      );
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: _interval.transform(notifier.menuProgress),
          child: Column(
            children: buildMenuItems(notifier),
          ),
        );
      },
    );
  }
}

class MenuItem extends StatefulWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool isSelected;

  const MenuItem({
    Key key,
    @required this.title,
    @required this.icon,
    this.onTap,
    this.isSelected = false,
  })  : assert(title != null && icon != null),
        super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterLayout());
  }

  void afterLayout() {
    final renderBox = context.findRenderObject() as RenderBox;
    Provider.of<MenuNotifier>(context, listen: false)
        .setIndicatorHeight(renderBox.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isSelected ? null : widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32),
        child: Row(
          children: <Widget>[
            widget.icon,
            const SizedBox(width: 16),
            Text(
              widget.title,
            ),
          ],
        ),
      ),
    );
  }
}
