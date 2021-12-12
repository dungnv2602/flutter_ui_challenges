/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import '../utils.dart';

class SlidingDrawer extends StatelessWidget {
  final Widget drawer;
  final OpenableController controller;
  final SlidingDrawerDirection direction;

  const SlidingDrawer({
    Key key,
    @required this.controller,
    @required this.drawer,
    this.direction = SlidingDrawerDirection.right,
  })  : assert(controller != null),
        assert(drawer != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // tap outside drawer will close it off
        GestureDetector(
          onTap: controller.isOpened ? controller.close : null,
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            final translationOffset = direction == SlidingDrawerDirection.right
                ? Offset(1 - controller.value, 0)
                : Offset(controller.value - 1, 0);
            return FractionalTranslation(
              translation: translationOffset,
              child: child,
            );
          },
          child: Align(
            alignment: direction == SlidingDrawerDirection.right
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: drawer,
          ),
        ),
      ],
    );
  }
}

enum SlidingDrawerDirection { left, right }
