/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'models.dart';

class ActorScroller extends StatelessWidget {
  final List<Actor> actors;

  const ActorScroller({Key key, this.actors}) : super(key: key);

  Widget _buildActor(BuildContext context, int index) {
    final actor = actors[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(actor.avatarUrl),
            radius: 40,
          ),
       const    SizedBox(height: 8),
          Text(actor.name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:const  EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Actors',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),

        ///One thing to note is that we also wrap the ListView in a SizedBox widget with a predefined height. Otherwise our ListView will take an infinite height which results in some UI constraint errors, since it’s already wrapped in a scroll view.
        SizedBox.fromSize(
            size: const Size.fromHeight(120.0),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12.0, left: 20.0),
              itemCount: actors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: _buildActor,
            ))
      ],
    );
  }
}
