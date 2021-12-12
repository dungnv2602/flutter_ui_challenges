/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// design: https://dribbble.com/shots/3845034-Listening-now-Kishi-Bashi
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements

import 'dart:ui';

import 'package:flutter/material.dart';

import 'slider_dragger.dart';
import 'slider_goo.dart';
import 'slider_marks.dart';
import 'slider_points.dart';
import 'springy_slider_controller.dart';

const _backgroundColor = Colors.white;
const _primaryColor = Color(0xFFFF6688);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildTextButton(String title, bool isWhite) {
    return FlatButton(
      onPressed: () {},
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isWhite ? _primaryColor : Colors.white,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: _primaryColor),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          _buildTextButton('SETTINGS', true),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            child: SpringySlider(
              initialPercent: 0.5,
              markCount: 12,
              positiveColor: _primaryColor,
              negativeColor: _backgroundColor,
              paddingTop: 24,
              paddingBottom: 24,
            ),
          ),
          Container(
            color: _primaryColor,
            child: Row(
              children: <Widget>[
                _buildTextButton('MORE', false),
                Expanded(child: Container()),
                _buildTextButton('STATS', false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpringySlider extends StatefulWidget {
  final int markCount;
  final Color positiveColor;
  final Color negativeColor;
  final double paddingTop;
  final double paddingBottom;
  final double initialPercent;

  const SpringySlider({
    Key key,
    @required this.initialPercent,
    @required this.markCount,
    @required this.positiveColor,
    @required this.negativeColor,
    @required this.paddingTop,
    @required this.paddingBottom,
  })  : assert(initialPercent != null),
        assert(markCount != null),
        assert(positiveColor != null),
        assert(negativeColor != null),
        assert(paddingTop != null),
        assert(paddingBottom != null),
        super(key: key);

  @override
  _SpringySliderState createState() => _SpringySliderState();
}

class _SpringySliderState extends State<SpringySlider>
    with TickerProviderStateMixin {
  SpringySliderController sliderController;

  void initSpringySliderController() {
    sliderController = SpringySliderController(
      vsync: this,
      sliderPercent: widget.initialPercent,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SliderDragger(
      sliderController: sliderController,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      child: Stack(
        children: <Widget>[
          /// marks in background
          SliderMarks(
            markCount: widget.markCount,
            markColor: widget.positiveColor,
            backgroundColor: widget.negativeColor,
            paddingTop: widget.paddingTop,
            paddingBottom: widget.paddingBottom,
          ),

          /// marks in foreground
          SliderGoo(
            sliderController: sliderController,
            paddingTop: widget.paddingTop,
            paddingBottom: widget.paddingBottom,
            child: SliderMarks(
              markCount: widget.markCount,
              markColor: widget.negativeColor,
              backgroundColor: widget.positiveColor,
              paddingTop: widget.paddingTop,
              paddingBottom: widget.paddingBottom,
            ),
          ),

          /// numbers
          SliderPoints(
            sliderController: sliderController,
            paddingTop: widget.paddingTop,
            paddingBottom: widget.paddingBottom,
            topColor: widget.positiveColor,
            bottomColor: widget.negativeColor,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initSpringySliderController();
  }

  @override
  void didUpdateWidget(SpringySlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPercent != oldWidget.initialPercent) {
      initSpringySliderController();
    }
  }

  @override
  void dispose() {
    sliderController.dispose();
    super.dispose();
  }
}

class _SliderDebugger extends StatelessWidget {
  final double sliderPercent;

  final double paddingTop;
  final double paddingBottom;

  const _SliderDebugger({
    Key key,
    @required this.sliderPercent,
    this.paddingTop = 0,
    this.paddingBottom = 0,
  })  : assert(sliderPercent != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight - paddingTop - paddingBottom;
        return Stack(children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: height * (1 - sliderPercent) + paddingTop,
            child: Container(
              height: 2,
              color: Colors.black,
            ),
          ),
        ]);
      },
    );
  }
}
