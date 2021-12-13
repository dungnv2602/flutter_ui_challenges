import 'package:flutter/material.dart';

import 'util/utils.dart';

class MenuTexts extends StatelessWidget {
  final Animation controller;
  final ValueChanged<int> onPressed;
  final int selectedIndex;

  const MenuTexts({Key key, @required this.controller, @required this.onPressed, @required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Row(
        children: <Widget>[
          MenuText(
            title: 'Forum',
            isSelected: selectedIndex == 0,
            onTap: () {
              onPressed(0);
            },
          ),
          SizedBox(width: 84),
          MenuText(
            title: 'Streamers',
            isSelected: selectedIndex == 1,
            onTap: () {
              onPressed(1);
            },
          ),
          SizedBox(width: 84),
          MenuText(
            title: 'Media',
            isSelected: selectedIndex == 2,
            onTap: () {
              onPressed(2);
            },
          ),
        ],
      ),
    );
  }
}

class MenuText extends StatelessWidget {
  final bool isSelected;
  final String title;
  final VoidCallback onTap;
  final Duration duration;

  const MenuText(
      {Key key,
      @required this.isSelected,
      @required this.title,
      @required this.onTap,
      this.duration = const Duration(milliseconds: 250)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelected ? null : onTap,
      child: AnimatedDefaultTextStyle(
        duration: duration,
        style: isSelected ? selectedTabStyle : defaultTabStyle,
        child: Text(title),
      ),
    );
  }
}
