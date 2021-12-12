/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:core';

class DestinationModel {
  final String id;
  final String title;
  final String description;
  final List<String> imgAssetsPath;

  DestinationModel({
    this.id,
    this.title,
    this.description,
    this.imgAssetsPath,
  });
}

final List<DestinationModel> destinations = [
  DestinationModel(
    id: 'Redang',
    title: 'Redang',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/images/page_transition/beach1.jpg',
      'assets/images/page_transition/beach2.jpg',
      'assets/images/page_transition/beach3.jpeg',
    ],
  ),
  DestinationModel(
    id: 'Tioman',
    title: 'Tioman',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/images/page_transition/beach2.jpg',
      'assets/images/page_transition/beach1.jpg',
      'assets/images/page_transition/beach3.jpeg',
    ],
  ),
  DestinationModel(
    id: 'Kapas',
    title: 'Kapas',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/images/page_transition/beach3.jpeg',
      'assets/images/page_transition/beach1.jpg',
      'assets/images/page_transition/beach2.jpg',
    ],
  ),
  DestinationModel(
    id: 'Desaru',
    title: 'Desaru',
    description:
        'Perak\'s finest colonial architecture stands side by side with rickety kedai kopi (coffee shops) in chameleonic Ipoh.',
    imgAssetsPath: [
      'assets/images/page_transition/beach4.jpg',
      'assets/images/page_transition/beach2.jpg',
      'assets/images/page_transition/beach3.jpeg',
    ],
  ),
];
