/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'music_player.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: const Color(0x44000000),
      color: accentColor,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          RichText(
            text: TextSpan(
              text: '',
              children: [
                TextSpan(
                  text: 'Song Title\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: 'Artist Name',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                    letterSpacing: 3,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: <Widget>[
              const Spacer(),
              SkipButton(
                icon: Icons.skip_previous,
                onPressed: () {},
              ),
              const Spacer(),
              PlayButton(
                onPressed: () {},
              ),
              const Spacer(),
              SkipButton(
                icon: Icons.skip_next,
                onPressed: () {},
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlayButton({
    Key key,
    @required this.onPressed,
  })  : assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: const CircleBorder(),
      fillColor: Colors.white,
      splashColor: lightAccentColor,
      highlightColor: lightAccentColor.withOpacity(0.5),
      elevation: 10,
      highlightElevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.play_arrow,
          color: darkAccentColor,
          size: 36,
        ),
      ),
      onPressed: () {},
    );
  }
}

class SkipButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SkipButton({
    Key key,
    @required this.icon,
    @required this.onPressed,
  })  : assert(icon != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      onPressed: onPressed,
      iconSize: 32,
    );
  }
}
