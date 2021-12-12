/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// design: https://dribbble.com/shots/2764686-Original-timer-app-UX-interaction
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'egg_timer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: eggTimerGradientColors,
            ),
          ),
          child: ChangeNotifierProvider<CountdownTimer>(
            create: (_) => CountdownTimer(maxTime: const Duration(minutes: 35)),
            child: Column(
              children: const <Widget>[
                TimeDisplay(),
                EggTimerDial(),
                Spacer(),
                TimeControls(),
              ],
            ),
          ),
        ),
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
        fontFamily: 'BebasNeue',
      ),
      home: HomePage(),
    );
  }
}

const eggTimerGradientColors = [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];
