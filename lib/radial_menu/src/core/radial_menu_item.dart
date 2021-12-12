/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

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
