/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'image_hero.dart';
import 'member_details_page.dart';
import 'resources/models.dart';
import 'resources/sizes.dart';
import 'resources/text_styles.dart';

class MemberWidget extends StatelessWidget {
  final Member member;
  final bool compactMode;

  const MemberWidget({Key key, @required this.member, this.compactMode = false}) : super(key: key);

  Future<PaletteGenerator> _generatePalette(BuildContext context, String imagePath) async {
    return PaletteGenerator.fromImageProvider(AssetImage(imagePath), size:const  Size(110, 150), maximumColorCount: 20);
  }

  @override
  Widget build(BuildContext context) {
    final names = member.name.split(' ');

    final onTap = () {
      _generatePalette(context, member.imagePath).then((palette) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MemberDetailsPage(member: member, palette: palette)));
      });
    };

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageHero(
              tag: member.name,
              height: 150,
              width: 110,
              fit: BoxFit.cover,
              imagePath: member.imagePath,
              onTap: onTap,
            ),
          ),
        const   SizedBox(height: size_20),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  names[0],
                  style: nameStyle,
                ),
                Text(
                  names[1],
                  style: nameStyle,
                ),
                SizedBox(height: size_8),
                Text(
                  member.occupation,
                  style: occupationStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
