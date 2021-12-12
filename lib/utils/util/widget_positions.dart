/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/widgets.dart';

WidgetContentOrientation getWidgetContentOrientation(
    BuildContext context, Offset position,
    {double gap = 0}) {
  if (isCloseToTopOrBottom(context, position, gap: gap)) {
    if (isOnTopHalfOfScreen(context, position)) {
      return WidgetContentOrientation.below;
    } else {
      return WidgetContentOrientation.above;
    }
  } else {
    if (isOnTopHalfOfScreen(context, position)) {
      return WidgetContentOrientation.above;
    } else {
      return WidgetContentOrientation.below;
    }
  }
}

bool isCloseToTopOrBottom(BuildContext context, Offset position,
    {double gap = 0}) {
  return position.dy <= gap || (_screenHeight(context) - position.dy) <= gap;
}

bool isOnTopHalfOfScreen(BuildContext context, Offset position) {
  return position.dy < _screenHeight(context) / 2;
}

bool isOnLeftHalfOfScreen(BuildContext context, Offset position) {
  return position.dx < _screenWidth(context) / 2;
}

double _screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double _screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

enum WidgetContentOrientation {
  above,
  below,
}
