/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// Implementation originated by: https://github.com/tunitowen/f1_animation
/// With my own workarounds and improvements
/// source: https://dribbble.com/shots/6518553-Formula-1-Drivers-Browsing
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'f1_scroll_physics.dart';

import 'models.dart';


const String ALL_CHARS = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 Paging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "PTMono",
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController;
  ScrollController _flagController;

  double pageOffset = 0.0;

  int driverNumber = 0;
  String firstName = "";
  String lastName = "";
  String team = "";

  double get screenWidth => MediaQuery.of(context).size.width * 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _flagController = ScrollController();

    driverNumber = drivers[0].driverNumber;
    team = drivers[0].team;
    firstName = drivers[0].firstName;
    lastName = drivers[0].lastName;

    _scrollController.addListener(() {
      setState(() {
        pageOffset = _scrollController.offset / screenWidth;
        debugPrint('pageOffset: $pageOffset');

        driverNumber = _calculateDriverNumber();
        firstName = _calculateCharacters(StringType.FIRST_NAME);
        lastName = _calculateCharacters(StringType.LAST_NAME);
        team = _calculateCharacters(StringType.TEAM);

        _flagController.animateTo(pageOffset * 64, duration: Duration(milliseconds: 50), curve: Curves.easeIn);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            physics: F1ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: drivers.length,
            itemBuilder: (_, index) {
              return Image.asset(
                'assets/images/formula_1/${drivers[index].image}.jpg',
                width: screenWidth,
                fit: BoxFit.none,
                scale: 1.3,
                alignment: Alignment(0, -0.9),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  child: Text(
                    driverNumber.toString(),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                Text(
                  firstName,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Text(
                  lastName,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Text(
                  team,
                  style: TextStyle(fontSize: 20, color: Colors.white54),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 160, horizontal: 56),
            child: SizedBox(
              width: 32,
              height: 32,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                controller: _flagController,
                itemCount: drivers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return Image.asset(
                    "assets/images/formula_1/${drivers[index].nationality}.png",
                    height: 32,
                    width: 32,
                  );
                },
                separatorBuilder: (_, index) {
                  return Container(
                    width: 32,
                    height: 32,
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: CustomPaint(
              foregroundPainter: ScrollIndicatorPainter(pageOffset + 1),
              child: Container(
                width: double.infinity,
                height: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDriverNumber() {
    final lastDriverNumber = drivers[pageOffset.floor()].driverNumber;
    final nextDriverNumber = drivers[pageOffset.ceil()].driverNumber;
    final offset = pageOffset % 1;
//    debugPrint('offset $offset');

    final cal = ((lastDriverNumber - nextDriverNumber) * offset).round();
//    debugPrint('cal $cal');

    return lastDriverNumber - cal;
  }

  String _calculateCharacters(StringType stringType) {
    String last = "";
    String next = "";

    switch (stringType) {
      case StringType.FIRST_NAME:
        {
          last = drivers[pageOffset.floor()].firstName;
          next = drivers[pageOffset.ceil()].firstName;
          break;
        }
      case StringType.LAST_NAME:
        {
          last = drivers[pageOffset.floor()].lastName;
          next = drivers[pageOffset.ceil()].lastName;
          break;
        }
      default:
        {
          last = drivers[pageOffset.floor()].team;
          next = drivers[pageOffset.ceil()].team;
          break;
        }
    }

    int longestTeam = math.max(last.length, next.length);

    String currentTeam = "";

    for (int i = 0; i < longestTeam; i++) {
      String lastTeamChar = " ";
      String nextTeamChar = " ";

      try {
        lastTeamChar = last[i];
      } catch (e) {}
      try {
        nextTeamChar = next[i];
      } catch (e) {}

      int lastIndex = ALL_CHARS.indexOf(lastTeamChar);
      int nextIndex = ALL_CHARS.indexOf(nextTeamChar);

      double currentFraction = pageOffset % 1;

      int currentIndex = lastIndex - ((lastIndex - nextIndex) * currentFraction).round();

      currentTeam = currentTeam + ALL_CHARS[currentIndex];
    }

    return currentTeam;
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final double offset;

  final Paint trackPaint = Paint()
    ..color = const Color(0xFFB9B5B4).withOpacity(0.5)
    ..style = PaintingStyle.fill;
  final Paint thumbPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  ScrollIndicatorPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    // draw track
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        trackPaint);

    //draw thumb
    final thumbWidth = size.width / drivers.length * offset;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0,
            0,
            thumbWidth,
            size.height,
          ),
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
