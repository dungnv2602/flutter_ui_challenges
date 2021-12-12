import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:sized_context/sized_context.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class MenuTitle extends StatelessWidget {
  const MenuTitle({
    Key key,
    @required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        final animationValue = _curve.transform(animation.value);

        return Transform(
          transform: Matrix4.translationValues(
            250 * (1 - animationValue),
            0,
            0,
          ),
          child: child,
        );
      },
      child: const Text(
        'Menu',
        style: TextStyle(
          color: Color(0x88444444),
          fontSize: 250,
        ),
        textAlign: TextAlign.left,
        softWrap: false,
      ),
    );
  }
}

class HiddenMenuItems extends StatefulWidget {
  const HiddenMenuItems({
    Key key,
    @required this.controller,
    @required this.models,
    this.initialSelected = 0,
    this.onItemSelected,
  })  : assert(initialSelected <= models.length - 1),
        super(key: key);

  final OpenableController controller;
  final List<HiddenMenuItemModel> models;
  final ValueChanged<int> onItemSelected;
  final int initialSelected;

  @override
  _HiddenMenuItemsState createState() => _HiddenMenuItemsState();
}

class _HiddenMenuItemsState extends State<HiddenMenuItems>
    with
        AnimationControllerMixin,
        SingleTickerProviderStateMixin,
        AfterLayoutMixin {
  @override
  AnimationConfig get animationControllerConfig => AnimationConfig(
        vsync: this,
        curve: Curves.easeOut,
      );

  List<GlobalKey> _menuItemKeys;
  int _selectedIndex;
  Rect _indicatorRect = Rect.zero;

  bool _isSelected(int index) => _selectedIndex == index;

  Curve menuItemSlideAtIndex(int index) => _menuItemSlides[index];
  List<Curve> _menuItemSlides;
  List<Curve> initializeMenuItemSlides(int itemCount) {
    const slideInterval = 0.1;
    final slideTime = 1 - itemCount / 10;

    return List.generate(
      itemCount,
      (index) {
        final start = index * slideInterval;
        final interval = Interval(start, start + slideTime);
        return interval;
      },
      growable: false,
    );
  }

  @override
  void initState() {
    super.initState();
    animationController.addListener(() => setState(() {}));
    _selectedIndex = widget.initialSelected;
    _menuItemKeys = List.generate(widget.models.length, (index) => GlobalKey(),
        growable: false);
    _menuItemSlides = initializeMenuItemSlides(widget.models.length);
  }

  @override
  void afterLayout(BuildContext context) {
    _indicatorRect = _getSelectedMenuItemRect;
  }

  Rect get _getSelectedMenuItemRect {
    return boundingBoxFor(_menuItemKeys[_selectedIndex].currentContext);
  }

  Widget buildMenuItem(
      OpenableController controller, int index, HiddenMenuItemModel model) {
    final menuItem = HiddenMenuItem(
      key: _menuItemKeys[index],
      title: model.title,
      icon: model.icon,
      color: _isSelected(index) ? Colors.red : Colors.white,
      onPressed: () {
        if (_isSelected(index)) return;
        setState(() {
          _selectedIndex = index;
        });
        animationController
            .forward(from: 0)
            .then((_) => widget.onItemSelected?.call(index));
      },
    );

    switch (controller.state) {
      case OpenableState.closed:
      case OpenableState.closing:
        return FadeTransition(
          opacity: controller.animation,
          child: menuItem,
        );
      case OpenableState.opened:
      case OpenableState.opening:
        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Transform(
              transform: Matrix4.translationValues(
                0,
                context.heightPx * (1 - controller.value),
                0,
              ),
              child: menuItem,
            );
          },
        );
    }

    return menuItem;
  }

  List<Widget> buildMenuItems(OpenableController controller) {
    final menuItems = <Widget>[];
    for (var index = 0; index < widget.models.length; index++) {
      final model = widget.models[index];
      menuItems.add(buildMenuItem(controller, index, model));
    }
    return menuItems;
  }

  Widget buildMenuItemIndicator() {
    return Container(
      color: Colors.red,
      height: _indicatorRect.height,
      width: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: buildMenuItems(widget.controller)),
      ],
    );
  }
}

class HiddenMenuItem extends StatefulWidget {
  const HiddenMenuItem({
    Key key,
    this.icon,
    this.color,
    @required this.title,
    this.onPressed,
  })  : assert(title != null),
        super(key: key);

  final Widget icon;
  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  _HiddenMenuItemState createState() => _HiddenMenuItemState();
}

class _HiddenMenuItemState extends State<HiddenMenuItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterLayout());
  }

  void afterLayout() {
    final renderBox = getRenderBoxFromContext(context);
    // Provider.of<MenuNotifier>(context, listen: false)
    //     .setIndicatorHeight(renderBox.size.height);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      splashColor: const Color(0x44000000),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32),
        child: Row(
          children: <Widget>[
            if (widget.icon != null) widget.icon,
            const SizedBox(width: 16),
            Text(
              widget.title,
              style: context.headline6.letterSpace(2).textColor(widget.color),
            ),
          ],
        ),
      ),
    );
  }
}

class HiddenMenuItemModel {
  const HiddenMenuItemModel({
    this.icon,
    @required this.title,
  });

  final Widget icon;
  final String title;
}
