/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'models.dart';
import 'util.dart';

class CharacterWidget extends StatelessWidget {
  final Character character;
  final PageController pageController;
  final int currentPage;

  const CharacterWidget({
    Key key,
    @required this.character,
    @required this.pageController,
    @required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetailScreen(character: character);
            }));
      },
      child: AnimatedBuilder(
        animation: pageController,
        builder: (_, child) {
          double value = 1;
          if (pageController.position.haveDimensions) {
            value = pageController.page - currentPage;
            value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
          }
          return Stack(
            children: <Widget>[
              Positioned(
                height: height * 0.6,
                bottom: 32,
                left: 24,
                right: 24,
                child: ClipPath(
                  clipper: CurvedClipper(),
                  child: Hero(
                    tag: 'background-${character.name}',
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: character.colors,
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment:const  Alignment(0, -1),
                child: Hero(
                  tag: 'image-${character.name}',
                  child: Image.asset(
                    character.imagePath,
                    height: height * 0.6 * value,
                  ),
                ),
              ),
              Positioned(
                bottom: 48,
                left: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'name-${character.name}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(character.name, style: TextUtils.heading),
                      ),
                    ),
                    Text('Tap to read more', style: TextUtils.subHeading),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const  offset = 40.0;

    path.moveTo(0, size.height * 0.4);
    path.lineTo(0, size.height - offset);
    path.quadraticBezierTo(0, size.height, offset, size.height);
    path.lineTo(size.width - offset, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - offset);
    path.lineTo(size.width, offset);
    path.quadraticBezierTo(size.width, 0, size.width - offset, offset / 3);
    path.lineTo(offset, size.height * 0.3 - 5);
    path.quadraticBezierTo(1, size.height * 0.30 + 10, 0, size.height * 0.4);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return this != oldClipper;
  }
}
