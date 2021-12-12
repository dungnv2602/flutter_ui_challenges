/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// design: https://dribbble.com/shots/1212896-Weather-Rebound-gif
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements
///
import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

import 'forecast.dart';
import 'forecast_app_bar.dart';
import 'sliding_radial_list/index.dart';
import 'week_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  OpenableController drawerController;
  SlidingRadialListViewController slidingRadialListController;

  final selectedIndexDate = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          /// forecast
          Forecast(
            listViewModel: forecastRadialList,
            slidingRadialListController: slidingRadialListController,
          ),

          /// app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ForecastAppBar(
              selectedIndexDate: selectedIndexDate,
              onDrawerArrowTap: drawerController.open,
            ),
          ),

          /// drawer
          SlidingDrawer(
            controller: drawerController,
            drawer: WeekDrawer(
              onIndexDateSelected: (index) async {
                selectedIndexDate.value = index;
                drawerController.close();
                await slidingRadialListController.close();
                await slidingRadialListController.open();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    drawerController = OpenableController(vsync: this);

    slidingRadialListController = SlidingRadialListViewController(
      vsync: this,
      itemCount: forecastRadialList.items.length,
    )..open();
  }

  @override
  void dispose() {
    drawerController.dispose();
    slidingRadialListController.dispose();
    super.dispose();
  }
}
