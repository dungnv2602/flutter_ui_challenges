/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class WeekDrawer extends StatelessWidget {
  const WeekDrawer({Key key, @required this.onIndexDateSelected})
      : assert(onIndexDateSelected != null),
        super(key: key);

  final Function(int index) onIndexDateSelected;

  List<Widget> _buildDayButtons() {
    return _weatherForecastDates.map(
      (day) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onIndexDateSelected(_weatherForecastDates.indexOf(day)),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: double.infinity,
      color: const Color(0xAA234060),
      child: Column(
        children: <Widget>[
          const Expanded(
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 40,
            ),
          ),
          ..._buildDayButtons(),
        ],
      ),
    );
  }
}

const _weatherForecastDates = [
  'Monday\nAugust 28',
  'Tuesday\nAugust 29',
  'Wednesday\nAugust 30',
  'Thursday\nAugust 30',
  'Friday\nSeptember 01',
  'Saturday\nAugust 02',
  'Sunday\nAugust 03',
];
