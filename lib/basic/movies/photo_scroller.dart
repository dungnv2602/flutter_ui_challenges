/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

class PhotoScroller extends StatelessWidget {
  final List<String> photoUrls;

  const PhotoScroller({Key key, this.photoUrls}) : super(key: key);

  Widget _buildPhoto(BuildContext context, int index) {
    final photo = photoUrls[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          photo,
          width: 160,
          height: 120,
          fit: BoxFit.cover,
        ),
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
            'Photos',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),

        ///One thing to note is that we also wrap the ListView in a SizedBox widget with a predefined height. Otherwise our ListView will take an infinite height which results in some UI constraint errors, since it’s already wrapped in a scroll view.
        SizedBox.fromSize(
            size: const Size.fromHeight(100.0),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0),
              itemCount: photoUrls.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: _buildPhoto,
            ))
      ],
    );
  }
}
