import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:provider/provider.dart';

import '../../menu_notifier.dart';
import 'commons.dart';
import 'signin_menu_item.dart';
import 'user_info_widget.dart';

class MenuView extends StatelessWidget {
  const MenuView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DarkElevationOverlay.fourDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 96),
          UserInfoWidget(),
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
    );
  }
}

class AnimatedIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const curve = MotionCurves.standardEasingHeavy;
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        final gap = notifier.indicatorHeight * notifier.indicatorSwitchingAnimationProgess;
        final heightGap = size.height * curve.transform(notifier.indicatorProgress) - gap;
        final top = size.height - heightGap;
        return Positioned(
          top: top,
          child: Opacity(
            // TODO(joe): be creative when it comes to opacity
            opacity: curve.transform(notifier.indicatorProgress),
            child: SizedBox(
              width: size.width,
              height: notifier.indicatorHeight,
              child: child,
            ),
          ),
        );
      },
      child: Row(
        children: <Widget>[
          Container(
            width: 5,
            color: primaryColor,
          ),
          Expanded(
            child: Container(
              color: mDarkTheme.colorTheme.states.surfaceOverlay,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedMenuItems extends StatelessWidget {
  List<Widget> buildMenuItems(MenuNotifier notifier) {
    final menuItems = <AnimatedMenuItem>[];
    for (var index = 0; index < notifier.items.length; index++) {
      final item = notifier.items[index];
      menuItems.add(
        AnimatedMenuItem(
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
          // TODO(joe): be creative when it comes to opacity
          opacity: interval.transform(notifier.menuProgress),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...buildMenuItems(notifier),
              const SizedBox(height: 24),
              SignInMenuItem(),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedMenuItem extends StatefulWidget {
  const AnimatedMenuItem({
    Key key,
    @required this.title,
    @required this.icon,
    this.onTap,
    this.isSelected = false,
  })  : assert(title != null && icon != null),
        super(key: key);

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  @override
  _AnimatedMenuItemState createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<AnimatedMenuItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterLayout());
  }

  void afterLayout() {
    final renderBox = context.findRenderObject() as RenderBox;
    // set indicator height equal menu item height
    Provider.of<MenuNotifier>(context, listen: false).setIndicatorHeight(renderBox.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      title: widget.title,
      icon: widget.icon,
      onTap: widget.onTap,
    );
  }
}
