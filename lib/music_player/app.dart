/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// design: https://uimovement.com/design/music-player-animation/
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements
///
// TODO(joe): take this git as resource for refactor/improvement: https://github.com/mjohnsullivan/dashcast/tree/flutterEurope/lib

import 'package:flutter/material.dart';

import 'music_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _seekPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: const Color(0xFFDDDDDD),
          onPressed: () {},
        ),
        title: const Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: const Color(0xFFDDDDDD),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          /// SeekBar
          Expanded(
            child: RadialSeekBar(
              seekPercent: _seekPercent,
              progress: 0.25,
              onSeekRequested: (double seekPercent) {
                setState(() {
                  _seekPercent = seekPercent;
                });
              },
            ),
          ),

          /// Visualizer
          Container(
            width: double.infinity,
            height: 125,
          ),

          /// BottomControls
          const BottomControls(),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}
