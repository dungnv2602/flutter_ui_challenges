/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * This class is a modified version from the original authored by Matt Carroll/Fluttery
 * Credit goes to Matt Carroll/Fluttery
 */

import 'dart:math';

import 'package:flutter/material.dart';
import '../../utils.dart';

/// Translate the [child] according to the [coord] given from the given [origin]
class PolarPosition extends StatelessWidget {
  final Offset origin;
  final PolarCoord coord;
  final Widget child;

  const PolarPosition({
    Key key,
    @required this.origin,
    @required this.coord,
    @required this.child,
  })  : assert(origin != null),
        assert(coord != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(joe): trigonometry
    final radialPosition = Offset(
      origin.dx + cos(coord.angle) * coord.radius,
      origin.dy + sin(coord.angle) * coord.radius,
    );

    return CenterAbout(
      position: radialPosition,
      child: child,
    );
  }
}
