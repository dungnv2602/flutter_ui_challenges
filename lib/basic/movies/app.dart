/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// Implementation originated by: https://iirokrankka.com/2017/09/12/from-design-to-flutter-movie-details-page/
/// With my own workarounds and improvements
/// Source: https://www.uplabs.com/posts/movie-interface
import 'package:flutter/material.dart';

import 'models.dart';
import 'movie_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Movie testMovie = Movie(
    bannerUrl: 'assets/images/banner.png',
    posterUrl: 'assets/images/poster.png',
    title: 'The Secret Life of Pets',
    rating: 8.0,
    starRating: 4,
    categories: ['Animation', 'Comedy'],
    storyline: 'For their fifth fully-animated feature-film '
        'collaboration, Illumination Entertainment and Universal '
        'Pictures present The Secret Life of Pets, a comedy about '
        'the lives our...',
    photoUrls: [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
    ],
    actors: [
      Actor(
        name: 'Louis C.K.',
        avatarUrl: 'assets/images/louis.png',
      ),
      Actor(
        name: 'Eric Stonestreet',
        avatarUrl: 'assets/images/eric.png',
      ),
      Actor(
        name: 'Kevin Hart',
        avatarUrl: 'assets/images/kevin.png',
      ),
      Actor(
        name: 'Jenny Slate',
        avatarUrl: 'assets/images/jenny.png',
      ),
      Actor(
        name: 'Ellie Kemper',
        avatarUrl: 'assets/images/ellie.png',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MovieDetailsPage(movie: testMovie);
  }
}
