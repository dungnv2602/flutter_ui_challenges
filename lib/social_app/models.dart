/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

const profiles = [
  Profile(
    imgPath: 'assets/images/members/amanda_minicucci.jpg',
    name: 'Lori Perez',
    country: 'France',
    city: 'Nantes',
    desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    followers: 123,
    posts: 456,
    followings: 789,
    photoPaths: imgPaths,
    isFollowed: false,
  ),
  Profile(
    imgPath: 'assets/images/members/jeenie_duhe.jpg',
    name: 'Lauren Turner',
    country: 'France',
    city: 'Paris',
    desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    followers: 435,
    posts: 12,
    followings: 643,
    photoPaths: imgPaths,
    isFollowed: true,
  ),
  Profile(
    imgPath: 'assets/images/members/kenneth_missliweck.jpeg',
    name: 'Joe Nguyen',
    country: 'Vietnam',
    city: 'Hanoi',
    desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    followers: 12308,
    posts: 100,
    followings: 5,
    photoPaths: imgPaths,
    isFollowed: false,
  ),
  Profile(
    imgPath: 'assets/images/members/gena_sedgwick.jpg',
    name: 'Dante',
    country: 'Italy',
    city: 'Venice',
    desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    followers: 1435,
    posts: 237,
    followings: 238,
    photoPaths: imgPaths,
    isFollowed: true,
  ),
];

const imgPaths = [
  'assets/images/members/amanda_minicucci.jpg',
  'assets/images/members/kenneth_missliweck.jpeg',
  'assets/images/members/jeenie_duhe.jpg',
  'assets/images/members/gena_sedgwick.jpg',
  'assets/images/members/amanda_minicucci.jpg',
  'assets/images/members/kenneth_missliweck.jpeg',
  'assets/images/members/jeenie_duhe.jpg',
  'assets/images/members/gena_sedgwick.jpg',
];

class Profile {
  final String name;
  final String imgPath;
  final String country;
  final String city;
  final String desc;
  final int followers;
  final int posts;
  final int followings;
  final List<String> photoPaths;
  final bool isFollowed;

  const Profile({
    this.name,
    this.imgPath,
    this.country,
    this.city,
    this.followers,
    this.posts,
    this.followings,
    this.desc,
    this.photoPaths,
    this.isFollowed,
  });
}
