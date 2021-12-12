/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// Implementation originated by: https://github.com/boeledi/guillotine
/// With my own workarounds and improvements
/// Source: https://dribbble.com/shots/2018249-Guillotine-Menu?list=users&offset=11
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          MainPage(),
          GuillotineMenu(),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xff222222));
  }
}

class GuillotineMenu extends StatefulWidget {
  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

class _GuillotineMenuState extends State<GuillotineMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotate;
  Animation<double> _fade;

  double get screenWidth => MediaQuery.of(context).size.width;

  double get screenHeight => MediaQuery.of(context).size.height;

  void _triggerMenu() {
    final status = _controller.status;
    status == AnimationStatus.dismissed ? _controller.forward() : _controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _rotate = Tween<double>(begin: -math.pi / 2, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut, reverseCurve: Curves.elasticIn));
    _fade = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Transform.rotate(
        angle: _rotate.value,

        /// The widget also allows us specify an origin for the rotation of our widget. We specify the origin using the origin parameter. This takes an Offset. The Offset notes the distance of the origin in relation to the center of the child itself. When the origin is left blank, the center of the widget is taken.
        /// Offset is 16 to the right and 40 below
        origin: Offset(16, 40),
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color(0xff333333),
            child: Stack(
              children: <Widget>[
                // Menu Title
                Positioned(
                  top: 32,
                  left: 40,
                  width: screenWidth,
                  height: 24,
                  child: Transform.rotate(
                    alignment: Alignment.topLeft,
                    angle: math.pi / 2,
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Opacity(
                          opacity: _fade.value,
                          child: Text(
                            'ACTIVITY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontFamily: 'Calibre-Semibold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Menu Icon
                Positioned(
                  top: 32,
                  left: 4,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: _triggerMenu,
                  ),
                ),
                // Menu Content
                Padding(
                  padding: const EdgeInsets.only(top: 96),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        MenuItem(
                          title: 'PROFILE',
                          iconData: Icons.person,
                          onPressed: (index) {},
                        ),
                        MenuItem(
                          title: 'FEED',
                          iconData: Icons.view_agenda,
                          onPressed: (index) {},
                        ),
                        MenuItem(
                          title: 'ACTIVITY',
                          selected: true,
                          iconData: Icons.swap_calls,
                          onPressed: (index) {},
                        ),
                        SizedBox(height: 64),
                        MenuItem(
                          title: 'SETTINGS',
                          iconData: Icons.settings,
                          onPressed: (index) {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  final ValueChanged<int> onPressed;

  const MenuItem({
    Key key,
    this.iconData,
    this.title,
    this.onPressed,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: selected ? null : () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(96, 16, 0, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                iconData,
                color: selected ? Colors.cyanAccent : Colors.white,
              ),
              SizedBox(width: 48),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.cyanAccent : Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'Calibre-Semibold',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
