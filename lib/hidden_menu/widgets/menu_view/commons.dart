import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:flutter_tmdb/views/widgets/widgets.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

const interval = Interval(0.5, 1, curve: Curves.fastOutSlowIn);

const loadingWidget = Padding(
  padding: EdgeInsets.only(top: 16, bottom: 16, left: 72),
  child: DarkCircularProgressIndicator(),
);

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key key,
    @required this.title,
    @required this.icon,
    this.onTap,
    this.isSelected = false,
  })  : assert(title != null && icon != null),
        super(key: key);

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? onSurfaceColorHigh : onSurfaceColorMedium;
    return DarkInkWell.elevated(
      borderRadius: BorderRadius.zero,
      onTap: isSelected ? null : onTap,
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: context.darkBodyText1.textColor(color),
          ),
        ],
      ),
    );
  }
}
