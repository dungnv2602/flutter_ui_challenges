/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'shared.dart';


class FlightImage extends StatelessWidget {
  final Flight flight;

  const FlightImage({Key key, @required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'flight-img-${flight.id}',
      child: Image.asset(
        flight.url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
