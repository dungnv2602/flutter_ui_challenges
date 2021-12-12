/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'models.dart';

class ProfileInfoRow extends StatelessWidget {
  final int index;

  const ProfileInfoRow({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = profiles[index];
    return Row(
      children: <Widget>[
        SizedBox(width: 24),
        StatisticsColumn(
          number: profile.followers,
          title: 'followers',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Spacer(),
        StatisticsColumn(
          number: profile.posts,
          title: 'posts',
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        Spacer(),
        StatisticsColumn(
          number: profile.followings,
          title: 'followings',
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
        SizedBox(width: 24),
      ],
    );
  }
}

class StatisticsColumn extends StatelessWidget {
  final int number;
  final String title;
  final CrossAxisAlignment crossAxisAlignment;

  const StatisticsColumn({
    Key key,
    this.number,
    this.crossAxisAlignment,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85)),
        )
      ],
    );
  }
}
