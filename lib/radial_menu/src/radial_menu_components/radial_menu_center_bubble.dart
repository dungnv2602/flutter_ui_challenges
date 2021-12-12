/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

part of radial_menu;

class RadialMenuCenterBubble extends StatelessWidget {
  final RadialMenuController menuController;
  final Offset anchorPosition;
  final double menuItemSize;
  final Color openCenterBubbleColor;
  final Color expandedCenterBubbleColor;
  final Widget openCenterBubbleIcon;
  final Widget expandedCenterBubbleIcon;

  const RadialMenuCenterBubble({
    Key key,
    @required this.menuController,
    @required this.anchorPosition,
    @required this.menuItemSize,
    @required this.openCenterBubbleColor,
    @required this.expandedCenterBubbleColor,
    @required this.openCenterBubbleIcon,
    @required this.expandedCenterBubbleIcon,
  })  : assert(menuController != null),
        assert(anchorPosition != null),
        assert(menuItemSize != null),
        assert(openCenterBubbleColor != null),
        assert(expandedCenterBubbleColor != null),
        assert(openCenterBubbleIcon != null),
        assert(expandedCenterBubbleIcon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: menuController,
      builder: (context, child) {
        Widget icon;
        Color bubbleColor;
        double scale = 1;
        double rotation = 0;
        VoidCallback onPressed;

        switch (menuController.state) {
          case RadialMenuState.closed:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = 0.0;
            break;
          case RadialMenuState.closing:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = 1.0 - menuController.progress;
            break;
          case RadialMenuState.opening:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = Curves.elasticOut.transform(menuController.progress);
            // rotate the icon counter-clockwise
            if (0 < menuController.progress && menuController.progress < 0.5) {
              rotation = lerpDouble(
                0,
                pi / 4,
                const Interval(0, 0.5).transform(menuController.progress),
              );
            } else {
              rotation = lerpDouble(
                pi / 4,
                0,
                const Interval(0.5, 1).transform(menuController.progress),
              );
            }
            break;
          case RadialMenuState.open:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = 1.0;
            onPressed = menuController.expand;
            break;
          case RadialMenuState.collapsing:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = 1.0;
            rotation = pi * Curves.easeOut.transform(menuController.progress);
            break;
          case RadialMenuState.expanding:
            icon = expandedCenterBubbleIcon;
            bubbleColor = expandedCenterBubbleColor;
            scale = 1.0;
            rotation = (pi / 2) *
                const Interval(0, 0.5, curve: Curves.easeOut)
                    .transform(menuController.progress);
            break;
          case RadialMenuState.expanded:
            icon = expandedCenterBubbleIcon;
            bubbleColor = expandedCenterBubbleColor;
            scale = 1.0;
            onPressed = menuController.collapse;
            break;
          case RadialMenuState.activating:
            icon = expandedCenterBubbleIcon;
            bubbleColor = expandedCenterBubbleColor;
            scale = lerpDouble(
              1.0,
              0.0,
              const Interval(0.0, 0.9, curve: Curves.easeOut)
                  .transform(menuController.progress),
            );
            break;
          case RadialMenuState.dissipating:
            icon = openCenterBubbleIcon;
            bubbleColor = openCenterBubbleColor;
            scale = lerpDouble(
              0.0,
              1.0,
              Curves.elasticOut.transform(menuController.progress),
            );
            if (0.0 < menuController.progress &&
                menuController.progress < 0.5) {
              rotation = lerpDouble(
                0.0,
                pi / 4,
                const Interval(0.0, 0.5).transform(menuController.progress),
              );
            } else {
              rotation = lerpDouble(
                pi / 4,
                0.0,
                const Interval(0.5, 1.0).transform(menuController.progress),
              );
            }
            break;
        }

        return CenterAbout(
          position: anchorPosition,
          child: Transform(
            transform: Matrix4.identity()
              ..scale(scale, scale)
              ..rotateZ(rotation),
            alignment: Alignment.center,
            child: RadialMenuBubble(
              size: menuItemSize,
              bubbleColor: bubbleColor,
              icon: icon,
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
}
