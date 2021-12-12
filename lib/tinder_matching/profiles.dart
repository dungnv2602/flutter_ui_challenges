/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

final List<Profile> demoProfiles = [
  Profile(
    photos: [
      'assets/images/carousel/bahama.jpg',
      'assets/images/carousel/capetown.jpg',
      'assets/images/carousel/dubai.jpg',
    ],
    name: 'Joe Nguyen',
    bio: 'American singer-songwriter',
  ),
  Profile(
    photos: [
      'assets/images/carousel/newyork.jpg',
      'assets/images/carousel/switzerland.jpg',
      'assets/images/carousel/tokyo.jpg',
    ],
    name: 'Hung Nguyen',
    bio: 'Vietnam singer-songwriter',
  ),
];

class Profile {
  Profile({this.photos, this.name, this.bio});

  final String bio;
  final String name;
  final List<String> photos;
}
