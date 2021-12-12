import 'package:flutter/material.dart';

import 'filter_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(body: MainPage()),
    );
  }
}

class MainPage extends StatefulWidget {
  static const paddingLeft = 32.0;
  static const headerHeight = 256.0;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // timeline
          Positioned(
            top: 0,
            bottom: 0,
            left: MainPage.paddingLeft,
            child: Container(width: 1, color: Colors.grey[300]),
          ),
          // header image
          const FilterTasksHeaderImg(
            height: MainPage.headerHeight,
            diagonalHeight: 60.0,
          ),
          // header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
            child: Row(
              children: <Widget>[
                Icon(Icons.menu, size: 32, color: Colors.grey[300]),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Timeline'),
                  ),
                ),
                Icon(Icons.linear_scale, color: Colors.grey[300]),
              ],
            ),
          ),
          // profile
          Padding(
            padding: const EdgeInsets.only(
                left: 16, top: MainPage.headerHeight / 2.5),
            child: Row(
              children: <Widget>[
                const Material(
                  shape: CircleBorder(),
                  elevation: 4,
                  child: CircleAvatar(
                    minRadius: 25,
                    maxRadius: 25,
                    backgroundImage:
                        AssetImage('assets/images/filter_menu/avatar.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Joe Ng'),
                    Text('Flutter Fan'),
                  ],
                ),
              ],
            ),
          ),
          // tasks
          FilterTasks(),
          // fab
          Positioned(
            top: MainPage.headerHeight - 100,
            right: -40,
            child: FilterTasksFAB(
              onPressed: () => FilterTasks.animatedTasksModel.removeAt(0),
            ),
          ),
        ],
      ),
    );
  }
}
