part of radial_menu;

class RadialMenuRadialBubbles extends StatelessWidget {
  final RadialMenuController menuController;
  final Offset anchorPosition;
  final List<RadialMenuItem> menuItems;
  final double menuItemSize;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final SweepDirection sweepDirection;

  const RadialMenuRadialBubbles({
    Key key,
    @required this.menuController,
    @required this.menuItems,
    @required this.anchorPosition,
    @required this.menuItemSize,
    @required this.radius,
    @required this.startAngle,
    @required this.sweepAngle,
    @required this.sweepDirection,
  })  : assert(menuController != null),
        assert(anchorPosition != null),
        assert(menuItems != null),
        assert(menuItemSize != null),
        assert(radius != null),
        assert(startAngle != null),
        assert(sweepAngle != null),
        assert(sweepDirection != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: menuController,
      builder: (context, child) {
        int index = 0;

        final itemCount = menuItems.length;

        final indexDivisor = sweepAngle == 2 * pi ? itemCount : itemCount - 1;

        final direction = sweepDirection == SweepDirection.clockwise ? 1 : -1;

        final sweepAngleDirection = sweepAngle * direction;

        final angleGap = sweepAngleDirection / indexDivisor;

        return Stack(
          children: menuItems.map(
            (RadialMenuItem item) {
              final angle = startAngle + angleGap * index;

              ++index;

              // hide the bubbles != expanding/expanded/collapsing/activating
              if (menuController.state == RadialMenuState.closed ||
                  menuController.state == RadialMenuState.closing ||
                  menuController.state == RadialMenuState.opening ||
                  menuController.state == RadialMenuState.open ||
                  menuController.state == RadialMenuState.dissipating) {
                return const SizedBox.shrink();
              }

              double bubbleRadius = radius;
              double scale = 1;

              if (menuController.state == RadialMenuState.expanding) {
                bubbleRadius = radius * Curves.elasticOut.transform(menuController.progress);
                scale = lerpDouble(
                    0.3, 1.0, const Interval(0.0, 0.3, curve: Curves.easeOut).transform(menuController.progress));
              } else if (menuController.state == RadialMenuState.collapsing) {
                bubbleRadius = radius * (1.0 - menuController.progress);
                scale = lerpDouble(0.3, 1.0, 1.0 - menuController.progress);
              }

              final coord = PolarCoord(angle, bubbleRadius);

              return PolarPosition(
                origin: anchorPosition,
                coord: coord,
                child: Transform(
                  transform: Matrix4.identity()..scale(scale, scale),
                  alignment: Alignment.center,
                  child: RadialMenuBubble(
                    size: menuItemSize,
                    bubbleColor: item.bubbleColor,
                    icon: item.icon,
                    onPressed: () {
                      menuController.activate(item);
                    },
                  ),
                ),
              );
            },
          ).toList(growable: false),
        );
      },
    );
  }
}
