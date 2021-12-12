/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

part of radial_menu;

class AnchoredRadialMenu extends StatelessWidget {
  final Widget child;
  final List<RadialMenuItem> menuItems;
  final double menuItemSize;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final SweepDirection sweepDirection;
  final Color openCenterBubbleColor;
  final Color expandedCenterBubbleColor;
  final Widget openCenterBubbleIcon;
  final Widget expandedCenterBubbleIcon;
  final int delayAfterMillis;
  final int openTimeMillis;

  const AnchoredRadialMenu({
    Key key,
    @required this.child,
    @required this.menuItems,
    this.menuItemSize = 50,
    this.radius = 75,
    this.startAngle = -pi / 2,
    this.sweepAngle = 2 * pi, // full circle
    this.sweepDirection = SweepDirection.clockwise,
    this.openCenterBubbleColor = const Color(0xFFAAAAAA),
    this.expandedCenterBubbleColor = const Color(0xFF666666),
    this.openCenterBubbleIcon = const Icon(
      Icons.menu,
      color: Colors.black,
    ),
    this.expandedCenterBubbleIcon = const Icon(
      Icons.clear,
      color: Colors.black,
    ),
    this.delayAfterMillis = 0,
    this.openTimeMillis = 250,
  })  : assert(child != null),
        assert(menuItems != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, Rect rect, Offset anchor) {
        return RadialMenu(
          menuItems: menuItems,
          anchorPosition: anchor,
          menuItemSize: menuItemSize,
          radius: radius,
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          sweepDirection: sweepDirection,
          openCenterBubbleColor: openCenterBubbleColor,
          expandedCenterBubbleColor: expandedCenterBubbleColor,
          openCenterBubbleIcon: openCenterBubbleIcon,
          expandedCenterBubbleIcon: expandedCenterBubbleIcon,
          delayAfterMillis: delayAfterMillis,
          openTimeMillis: openTimeMillis,
        );
      },
      child: child,
    );
  }
}
