import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'radial_menu.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Menu(
          startAngle: 0,
          sweepAngle: pi / 2,
        ),
        actions: <Widget>[
          Menu(
            startAngle: pi / 2,
            sweepAngle: pi / 2,
            sweepDirection: SweepDirection.clockwise,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // center
          Align(
            alignment: Alignment.center,
            child: Menu(
              startAngle: -pi / 2,
              sweepAngle: 2 * pi,
              sweepDirection: SweepDirection.counterClockwise,
            ),
          ),

          // middle left
          Align(
            alignment: Alignment.centerLeft,
            child: Menu(
              startAngle: -pi / 2,
              sweepAngle: pi,
            ),
          ),

          // middle right
          Align(
            alignment: Alignment.centerRight,
            child: Menu(
              startAngle: -pi / 2,
              sweepAngle: pi,
              sweepDirection: SweepDirection.counterClockwise,
            ),
          ),

          // bottom left
          Align(
            alignment: Alignment.bottomLeft,
            child: Menu(
              startAngle: -pi / 2,
              sweepAngle: pi / 2,
            ),
          ),

          // bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Menu(
              startAngle: -pi / 2,
              sweepAngle: pi / 2,
              sweepDirection: SweepDirection.counterClockwise,
            ),
          ),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final double startAngle;
  final double sweepAngle;
  final SweepDirection sweepDirection;

  const Menu({
    Key key,
    @required this.startAngle,
    @required this.sweepAngle,
    this.sweepDirection = SweepDirection.clockwise,
  })  : assert(startAngle != null),
        assert(sweepAngle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnchoredRadialMenu(
      menuItems: items,
      startAngle: startAngle,
      sweepAngle: sweepAngle,
      sweepDirection: sweepDirection,
      child: IconButton(
        icon: const Icon(
          Icons.cancel,
        ),
        onPressed: () {},
      ),
    );
  }
}

final items = [
  RadialMenuItem(
    icon: Icon(
      Icons.home,
      color: Colors.white,
    ),
    bubbleColor: Colors.blue,
    onPressed: () {
      debugPrint('id: 1');
    },
  ),
  RadialMenuItem(
    icon: Icon(
      Icons.search,
      color: Colors.white,
    ),
    bubbleColor: Colors.green,
    onPressed: () {
      debugPrint('id: 2');
    },
  ),
  RadialMenuItem(
    icon: Icon(
      Icons.alarm,
      color: Colors.white,
    ),
    bubbleColor: Colors.red,
    onPressed: () {
      debugPrint('id: 3');
    },
  ),
  RadialMenuItem(
    icon: Icon(
      Icons.settings,
      color: Colors.white,
    ),
    bubbleColor: Colors.purple,
    onPressed: () {
      debugPrint('id: 4');
    },
  ),
  RadialMenuItem(
    icon: Icon(
      Icons.location_on,
      color: Colors.white,
    ),
    bubbleColor: Colors.orange,
    onPressed: () {
      debugPrint('id: 5');
    },
  ),
];
