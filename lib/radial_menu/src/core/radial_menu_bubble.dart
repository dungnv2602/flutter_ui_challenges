/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

part of radial_menu;

class RadialMenuBubble extends StatelessWidget {
  final Color bubbleColor;
  final double size;
  final Widget icon;
  final VoidCallback onPressed;

  const RadialMenuBubble({
    Key key,
    @required this.bubbleColor,
    @required this.size,
    @required this.icon,
    this.onPressed,
  })  : assert(icon != null),
        assert(bubbleColor != null),
        assert(size != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bubbleColor,
        ),
        child: icon,
      ),
    );
  }
}
