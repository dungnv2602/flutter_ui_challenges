part of radial_menu;

class RadialMenu extends StatefulWidget {
  final List<RadialMenuItem> menuItems;
  final Offset anchorPosition;
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

  const RadialMenu({
    Key key,
    @required this.menuItems,
    @required this.anchorPosition,
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
    this.openTimeMillis = 0,
  })  : assert(anchorPosition != null),
        assert(menuItems != null),
        super(key: key);

  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin {
  RadialMenuController _menuController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RadialMenuRadialBubbles(
          menuController: _menuController,
          anchorPosition: widget.anchorPosition,
          menuItems: widget.menuItems,
          menuItemSize: widget.menuItemSize,
          radius: widget.radius,
          startAngle: widget.startAngle,
          sweepAngle: widget.sweepAngle,
          sweepDirection: widget.sweepDirection,
        ),
        RadialMenuCenterBubble(
          menuController: _menuController,
          anchorPosition: widget.anchorPosition,
          menuItemSize: widget.menuItemSize,
          openCenterBubbleColor: widget.openCenterBubbleColor,
          expandedCenterBubbleColor: widget.expandedCenterBubbleColor,
          openCenterBubbleIcon: widget.openCenterBubbleIcon,
          expandedCenterBubbleIcon: widget.expandedCenterBubbleIcon,
        ),
        RadialMenuActivationRibbon(
          menuController: _menuController,
          anchorPosition: widget.anchorPosition,
          menuItems: widget.menuItems,
          menuItemSize: widget.menuItemSize,
          radius: widget.radius,
          startAngle: widget.startAngle,
          sweepAngle: widget.sweepAngle,
          sweepDirection: widget.sweepDirection,
        ),
        RadialMenuActivationBubble(
          menuController: _menuController,
          anchorPosition: widget.anchorPosition,
          menuItems: widget.menuItems,
          menuItemSize: widget.menuItemSize,
          radius: widget.radius,
          startAngle: widget.startAngle,
          sweepAngle: widget.sweepAngle,
          sweepDirection: widget.sweepDirection,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // if no delay
    if (widget.delayAfterMillis == 0) {
      // if no open time
      if (widget.openTimeMillis == 0) {
        // display menu rightaway
        _menuController = RadialMenuController(vsync: this, state: RadialMenuState.open);
      } else {
        // animate opening menu at a given time
        _menuController = RadialMenuController(vsync: this, state: RadialMenuState.closed);
        _menuController.open(widget.openTimeMillis);
      }
    } else {
      // animate opening menu at a given time after delay
      _menuController = RadialMenuController(vsync: this, state: RadialMenuState.closed);
      // trigger open func after delayAfterMillis
      Timer(Duration(milliseconds: widget.delayAfterMillis), () {
        _menuController.open(widget.openTimeMillis);
      });
    }
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }
}

enum SweepDirection {
  clockwise,
  counterClockwise,
}
