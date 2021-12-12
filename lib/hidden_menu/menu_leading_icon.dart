import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:provider/provider.dart';

import 'menu_notifier.dart';

class MenuLeadingIcon extends StatelessWidget {
  const MenuLeadingIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (_, notifier, __) => IconButton(
        onPressed: notifier.toggle,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: notifier.menuAnimation,
          color: onSurfaceColorHigh,
        ),
      ),
    );
  }
}

class LogoAppBarWithMenuIcon extends StatelessWidget {
  const LogoAppBarWithMenuIcon({
    Key key,
    this.expanded,
  }) : super(key: key);
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return LogoAppBar(
      actionBarExpanded: expanded ?? true,
      actions: const [MenuLeadingIcon()],
    );
  }
}

class AppBarWithMenuIcon extends StatelessWidget {
  const AppBarWithMenuIcon({
    Key key,
    @required this.title,
    @required this.body,
  }) : super(key: key);
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuLeadingIcon(),
        title: Text(title, style: context.darkHeadline6),
      ),
      body: body,
    );
  }
}

class AnimatedMenuIconOverlay extends StatelessWidget {
  const AnimatedMenuIconOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMenuIcon(
      backgroundColor: DarkElevationOverlay.fourDpBlend,
      child: Consumer<MenuNotifier>(
        builder: (_, notifier, __) => FlatIconButton(
          onTap: notifier.toggle,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: notifier.menuAnimation,
            color: onSurfaceColorHigh,
          ),
        ),
      ),
    );
  }
}

class AnimatedCloseIconOverlay extends StatelessWidget {
  const AnimatedCloseIconOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMenuIcon(
      backgroundColor: DarkElevationOverlay.fourDpBlend,
      child: FlatIconButton(
        onTap: Navigator.of(context).maybePop,
        icon: Icon(
          Icons.close,
          color: onSurfaceColorHigh,
        ),
      ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  const _CustomIconButton({
    Key key,
    @required this.icon,
    @required this.onTap,
    this.padding,
  })  : assert(icon != null),
        super(key: key);

  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return FlatIconButton(
      onTap: onTap,
      icon: icon,
    );
  }
}

class CustomMenuIconModel {
  CustomMenuIconModel({@required this.icon, this.onTap}) : assert(icon != null);
  final IconData icon;
  final VoidCallback onTap;
}

class CustomMenuIcons extends StatelessWidget {
  const CustomMenuIcons({
    Key key,
    this.backgroundColor,
    this.shadowColor,
    this.iconSize,
    this.padding,
    @required this.children,
  })  : assert(iconSize != 0),
        assert(children != null),
        super(key: key);

  final Color backgroundColor;
  final Color shadowColor;

  final double iconSize;
  final List<CustomMenuIconModel> children;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final internalPadding = padding ?? const EdgeInsets.all(8);
    final internalIconSize = iconSize ?? Theme.of(context).iconTheme.size;

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: internalIconSize + internalPadding.horizontal,
          height: (internalIconSize + internalPadding.vertical) * (children.length + 1),
        ),
        child: CustomPaint(
          painter: MenuIconsPainter(
            painterColor: backgroundColor ?? Theme.of(context).primaryColor,
            shadowColor: shadowColor ?? Colors.black12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children
                .map<Widget>(
                  (child) => _CustomIconButton(
                    padding: internalPadding,
                    onTap: child.onTap,
                    icon: Icon(child.icon, size: internalIconSize),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class CustomMenuIcon extends StatelessWidget {
  const CustomMenuIcon({
    Key key,
    this.child,
    this.iconSize = kToolbarHeight,
    this.backgroundColor,
    this.shadowColor,
  })  : assert(iconSize != null && iconSize != 0),
        super(key: key);

  final Widget child;
  final double iconSize;
  final Color backgroundColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize * 2),
        child: CustomPaint(
          painter: MenuIconPainter(
            painterColor: backgroundColor ?? Theme.of(context).primaryColor,
            shadowColor: shadowColor ?? Colors.black12,
          ),
          child: Align(
            alignment: const FractionalOffset(0.0, 0.5),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MenuIconsPainter extends CustomPainter {
  MenuIconsPainter({
    @required this.painterColor,
    this.shadowColor,
  })  : assert(painterColor != null),
        drawShadow = shadowColor != null,
        painter = Paint()
          ..color = painterColor
          ..style = PaintingStyle.fill,
        path = Path();

  final Color shadowColor;
  final bool drawShadow;

  final Color painterColor;
  final Paint painter;
  final Path path;

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    // upper-curve
    path.cubicTo(
      // control point 1
      0.1 * width,
      0.1 * height,
      // control point 2
      1 * width,
      0.1 * height,
      // destination point
      1 * width,
      0.2 * height,
    );
    // line to 8/10 height to fill the upper-curve as well as the icons container
    path.lineTo(1 * width, 0.8 * height);
    path.lineTo(0, 0.8 * height);
    // move to bottom
    path.moveTo(0, height);
    // lower-curve
    path.cubicTo(
      // control point 1
      0.1 * width,
      0.9 * height,
      // control point 2
      1 * width,
      0.9 * height,
      // destination point
      1 * width,
      0.8 * height,
    );
    // line to 8/10 height to fill the lower-curve
    path.lineTo(0, 0.8 * height);

    canvas.drawPath(path, painter);

    if (drawShadow) canvas.drawShadow(path, shadowColor, 6, true);
  }

  @override
  bool shouldRepaint(MenuIconsPainter oldDelegate) => false;
}

// TODO(joe): parformance issue
class MenuIconPainter extends CustomPainter {
  MenuIconPainter({
    @required this.painterColor,
    this.shadowColor,
  })  : assert(painterColor != null),
        drawShadow = shadowColor != null,
        painter = Paint()
          ..color = painterColor
          ..style = PaintingStyle.fill,
        path = Path();

  final Color shadowColor;
  final bool drawShadow;

  final Color painterColor;
  final Paint painter;
  final Path path;

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    // upper-half
    path.cubicTo(
      1 / 10 * width,
      4 / 12 * height, // adjustible, the first curve
      9 / 10 * width,
      3.5 / 12 * height, // adjustible, the second curve
      9 / 10 * width,
      6 / 12 * height,
    );
    // line to center to fill the upper-half
    path.lineTo(0, 6 / 12 * height);
    // move to bottom
    path.moveTo(0, height);
    // lower-half
    path.cubicTo(
      1 / 10 * width,
      8 / 12 * height, // adjustible, the first curve
      9 / 10 * width,
      8.5 / 12 * height, // adjustible, the second curve
      9 / 10 * width,
      6 / 12 * height,
    );
    // line to center to fill the lower-half
    path.lineTo(0, 6 / 12 * height);

    canvas.drawPath(path, painter);

    if (drawShadow) canvas.drawShadow(path, shadowColor, 6, true);
  }

  @override
  bool shouldRepaint(MenuIconPainter oldDelegate) => false;
}
