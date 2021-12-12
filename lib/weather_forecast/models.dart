/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/widgets.dart';

const double centerPoint = 40.0;

const double baseCircleRadius = 140.0;

final RadialListViewModel forecastRadialList = RadialListViewModel(
  items: [
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_rain.png'),
      title: '11:30',
      subtitle: 'Light Rain',
      isSelected: true,
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_rain.png'),
      title: '12:30P',
      subtitle: 'Light Rain',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_cloudy.png'),
      title: '1:30P',
      subtitle: 'Cloudy',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_sunny.png'),
      title: '2:30P',
      subtitle: 'Sunny',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_sunny.png'),
      title: '3:30P',
      subtitle: 'Sunny',
    ),
  ],
);

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  const RadialListViewModel({
    this.items = const [],
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });
}
