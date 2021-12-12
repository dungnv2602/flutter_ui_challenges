/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class F1ScrollPhysics extends ScrollPhysics {
  const F1ScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  double _getPage(ScrollPosition position) {
    final page = position.pixels / (position.viewportDimension * 2);
//    debugPrint('Page: $page');
    return page;
  }

  double _getPixels(ScrollPosition position, double page) => page * (position.viewportDimension * 2);

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity)
      page -= 0.5;
    else if (velocity > tolerance.velocity) page += 0.5;
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final double target = _getTargetPixels(position, this.tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  ScrollPhysics applyTo(ScrollPhysics ancestor) {
    return F1ScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool get allowImplicitScrolling => false;
}
