import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:provider/provider.dart';

import '../menu_leading_icon.dart';
import '../menu_notifier.dart';

class SlideScaleView extends StatelessWidget {
  const SlideScaleView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<MenuNotifier>(
      builder: (_, notifier, __) {
        final value = MotionCurves.standardEasingHeavy.transform(notifier.menuProgress);
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
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // view
                ClipRRect(
                  borderRadius: BorderRadius.circular(16 * value),
                  child: selectedItem.child,
                ),
                // menu icon if required
                if (selectedItem.hasMenuIcon)
                  const LogoAppBarWithMenuIcon(),
                // add a layer to prevent tapping
                if (!notifier.isMenuClosed)
                  Column(
                    children: <Widget>[
                      // space for app bar for open/close menu
                      const SizedBox(height: kToolbarHeight + 16),
                      // space covers the rest to prevent tapping
                      AbsorbPointer(
                        absorbing: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16 * value),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
