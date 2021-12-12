/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

final models = [
  WeatherModel(
    'Capetown',
    'assets/images/carousel/capetown.jpg',
    '2-3',
    '65.1',
    'Mostly Cloudy',
    Icon(Icons.wb_cloudy, color: Colors.white),
    '11.2mph ENE',
  ),
  WeatherModel(
    'Newyork',
    'assets/images/carousel/newyork.jpg',
    '4-5',
    '5.1',
    'Sunny',
    Icon(Icons.wb_sunny, color: Colors.white),
    '1.12mph ENE',
  ),
  WeatherModel(
    'Switzerland',
    'assets/images/carousel/switzerland.jpg',
    '12-13',
    '6.15',
    'Mostly Cloudy',
    Icon(Icons.wb_cloudy, color: Colors.white),
    '112mph ENE',
  ),
  WeatherModel(
    'Dubai',
    'assets/images/carousel/dubai.jpg',
    '5-8',
    '6.51',
    'Sunny',
    Icon(Icons.wb_sunny, color: Colors.white),
    '1.2mph ENE',
  ),
  WeatherModel(
    'Bahama',
    'assets/images/carousel/bahama.jpg',
    '9-13',
    '51',
    'Mostly Cloudy',
    Icon(Icons.wb_cloudy, color: Colors.white),
    '2mph ENE',
  ),
  WeatherModel(
    'Tokyo',
    'assets/images/carousel/tokyo.jpg',
    '21-31',
    '165',
    'Rainy',
    Icon(Icons.wb_auto, color: Colors.white),
    '211mph ENE',
  ),
];

class WeatherModel {
  final String location;
  final String imagePath;
  final String degrees;
  final String humidity;
  final String condition;
  final Icon icon;
  final String windPower;

  WeatherModel(this.location, this.imagePath, this.degrees, this.humidity, this.condition, this.icon, this.windPower);
}
