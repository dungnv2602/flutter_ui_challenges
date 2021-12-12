/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'models.dart';

final titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
final subtitleStyle = TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5));
final buttonStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red, letterSpacing: 2);

class ProfileInfoBottomSheet extends StatelessWidget {
  final int index;

  const ProfileInfoBottomSheet({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = profiles[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 36),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(profile.name, style: titleStyle),
                Row(
                  children: <Widget>[
                    Text(profile.country, style: subtitleStyle),
                    Text(', ', style: subtitleStyle),
                    Text(profile.city, style: subtitleStyle),
                  ],
                ),
              ],
            ),
            Spacer(),
            FollowButton(profile: profile),
            SizedBox(width: 24),
          ],
        ),
        SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(profile.desc, style: subtitleStyle),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text('Photos', style: titleStyle),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: profile.photoPaths.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  width: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    elevation: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        profile.photoPaths[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}

class FollowButton extends StatefulWidget {
  final Profile profile;

  const FollowButton({Key key, @required this.profile}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return widget.profile.isFollowed
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: Icon(Icons.person, color: Colors.white)),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              border: Border.fromBorderSide(BorderSide(color: Colors.red, width: 2.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
              child: Center(child: Text('FOLLOW', style: buttonStyle)),
            ),
          );
  }
}
