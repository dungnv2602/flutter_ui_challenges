/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'actor_scroller.dart';
import 'models.dart';
import 'movie_detail_header.dart';
import 'photo_scroller.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MovieDetailHeader(movie: movie),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Storyline(storyline: movie.storyline),
            ),
            PhotoScroller(photoUrls: movie.photoUrls),
       const      SizedBox(height: 24.0),
            ActorScroller(actors: movie.actors),
          const   SizedBox(height: 48.0),
          ],
        ),
      ),
    );
  }
}

class Storyline extends StatelessWidget {
  final String storyline;

  const Storyline({Key key, this.storyline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Story line',
          style: textTheme.subhead.copyWith(fontSize: 18.0),
        ),
     const    SizedBox(height: 8.0),
        Text(
          storyline,
          style: textTheme.body1.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'more',
              style: textTheme.body1.copyWith(color: theme.accentColor, fontSize: 16.0),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.0,
              color: theme.accentColor,
            )
          ],
        )
      ],
    );
  }
}
