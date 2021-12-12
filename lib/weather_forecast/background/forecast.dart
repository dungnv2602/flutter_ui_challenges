/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import '../weather_forecast.dart';

class Forecast extends StatelessWidget {
  final RadialListViewModel listViewModel;
  final SlidingRadialListController slidingRadialListController;

  const Forecast({
    Key key,
    @required this.listViewModel,
    @required this.slidingRadialListController,
  })  : assert(listViewModel != null),
        assert(slidingRadialListController != null),
        super(key: key);
  Widget _temperatureText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 150, left: 10),
        child: Text(
          '68˚',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BackgroundWithRings(),
        _temperatureText(),
        SlidingRadialList(
          listViewModel: listViewModel,
          controller: slidingRadialListController,
        ),
      ],
    );
  }
}
