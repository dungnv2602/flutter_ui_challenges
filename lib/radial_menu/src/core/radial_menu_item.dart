part of radial_menu;

class RadialMenuItem {
  final Color bubbleColor;
  final Widget icon;
  final VoidCallback onPressed;

  RadialMenuItem({
    @required this.bubbleColor,
    @required this.icon,
    @required this.onPressed,
  })  : assert(bubbleColor != null),
        assert(onPressed != null),
        assert(icon != null);
}
