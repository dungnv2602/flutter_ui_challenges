/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

part of radial_menu;

class RadialMenuActivationRibbon extends StatelessWidget {
  final RadialMenuController menuController;
  final List<RadialMenuItem> menuItems;
  final Offset anchorPosition;
  final double menuItemSize;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final SweepDirection sweepDirection;

  const RadialMenuActivationRibbon({
    Key key,
    @required this.menuController,
    @required this.anchorPosition,
    @required this.menuItems,
    @required this.menuItemSize,
    @required this.radius,
    @required this.startAngle,
    @required this.sweepAngle,
    @required this.sweepDirection,
  })  : assert(menuController != null),
        assert(menuItems != null),
        assert(anchorPosition != null),
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
        // hide the painter if state # activating/dissipating
        if (menuController.state != RadialMenuState.activating &&
            menuController.state != RadialMenuState.dissipating) {
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

        double painterStartAngle;
        double painterEndAngle;
        double painterRadius;
        double opacity;

        if (menuController.state == RadialMenuState.activating) {
          final initialItemAngle = startAngle + angleGap * activeIndex;
          // full circle case => animate based on direction
          if (sweepAngle == 2 * pi) {
            painterStartAngle = initialItemAngle;
            painterEndAngle =
                initialItemAngle + sweepAngleDirection * menuController.progress;
            // half circle case => animate to edges
          } else {
            painterStartAngle = initialItemAngle -
                (initialItemAngle - startAngle) * menuController.progress;
            painterEndAngle = initialItemAngle +
                (endAngle - initialItemAngle) * menuController.progress;
          }
          painterRadius = radius;
          opacity = 1;
        } else if (menuController.state == RadialMenuState.dissipating) {
          painterStartAngle = startAngle;
          painterEndAngle = endAngle;
          // 25% more radius when dissipating
          final adjustedProgress =
              const Interval(0, 0.5).transform(menuController.progress);
          painterRadius = radius * (1 + (0.25 * adjustedProgress));
          opacity = 1 - adjustedProgress;
        }

        return CenterAbout(
          position: anchorPosition,
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              painter: _ActivationPainter(
                radius: painterRadius,
                startAngle: painterStartAngle,
                endAngle: painterEndAngle,
                thickness: menuItemSize,
                color: activeItem.bubbleColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActivationPainter extends CustomPainter {
  final double radius;
  final double thickness;
  final Color color;
  final double startAngle;
  final double endAngle;
  final Paint painter;

  _ActivationPainter({
    @required this.radius,
    @required this.thickness,
    @required this.color,
    @required this.startAngle,
    @required this.endAngle,
  })  : assert(radius != null),
        assert(thickness != null),
        assert(color != null),
        assert(startAngle != null),
        assert(endAngle != null),
        painter = Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, startAngle, endAngle - startAngle, false, painter);
  }

  @override
  bool shouldRepaint(_ActivationPainter oldDelegate) =>
      radius != oldDelegate.radius ||
      thickness != oldDelegate.thickness ||
      color != oldDelegate.color ||
      startAngle != oldDelegate.startAngle ||
      endAngle != oldDelegate.endAngle;

  @override
  bool shouldRebuildSemantics(_ActivationPainter oldDelegate) => false;
}
