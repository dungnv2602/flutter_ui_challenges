part of radial_menu;

class RadialMenuActivationBubble extends StatelessWidget {
  final RadialMenuController menuController;
  final List<RadialMenuItem> menuItems;
  final Offset anchorPosition;
  final double menuItemSize;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final SweepDirection sweepDirection;

  const RadialMenuActivationBubble({
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
        assert(startAngle != null),
        assert(sweepAngle != null),
        assert(sweepDirection != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: menuController,
      builder: (context, child) {
        // hide the bubble if state # activating
        if (menuController.state != RadialMenuState.activating) {
          return const SizedBox.shrink();
        }

        final activeItem = menuController.activeItem;

        final activeIndex = menuItems.indexOf(activeItem);

        final itemCount = menuItems.length;

        final indexDivisor = sweepAngle == 2 * pi ? itemCount : itemCount - 1;

        final direction = sweepDirection == SweepDirection.clockwise ? 1 : -1;

        final sweepAngleDirection = sweepAngle * direction;

        final angleGap = sweepAngleDirection / indexDivisor;

        final endAngle = startAngle + sweepAngleDirection;

        final initialItemAngle = startAngle + angleGap * activeIndex;

        double currentAngle;

        // full circle case
        if (sweepAngle == 2 * pi) {
          // bubble start at its original angle => run a full circle based on direction back to its original angle
          currentAngle = initialItemAngle + sweepAngleDirection * menuController.progress;
          // half circle case
        } else {
          // calculate the center angle based on start & end angle
          final centerAngle = lerpDouble(startAngle, endAngle, 0.5);
          // bubble start at its original angle => run a lerp between center angle and its original angle
          currentAngle = lerpDouble(initialItemAngle, centerAngle, menuController.progress);
        }

        return PolarPosition(
          origin: anchorPosition,
          coord: PolarCoord(currentAngle, radius),
          child: RadialMenuBubble(
            size: menuItemSize,
            bubbleColor: activeItem.bubbleColor,
            icon: activeItem.icon,
          ),
        );
      },
    );
  }
}
