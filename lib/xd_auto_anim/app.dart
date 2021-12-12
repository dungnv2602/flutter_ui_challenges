/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

// design: https://dribbble.com/shots/5551617-XD-Auto-Animation

// TODO fix padding card on small devices
// TODO fix transition animation

import 'package:flutter/material.dart';

import 'card_view.dart';
import 'details_view.dart';
import 'shared.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flight App Campaign',
      theme: ThemeData(
        primaryColor: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        fontFamily: 'SF-Pro-Display-Regular',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  PageController _pageController;

  final ValueNotifier<bool> _isBackedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _isBackedNotifier.addListener(() {
      if (_isBackedNotifier.value) {
        _animationController.reverse();
        _isBackedNotifier.value = false;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              _TopBar(controller: _animationController),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      pageSnapping: true,
                      itemCount: models.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () async {
                            _animationController.forward();

                            final bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailsView(index: index)));

                            _isBackedNotifier.value = result;
                          },
                          child: CardView(
                            controller: _pageController,
                            index: index,
                          ),
                        );
                      },
                    ),
                    MockView(),
                    MockView(),
                    MockView(),
                  ],
                ),
              ),
              _BottomBar(controller: _animationController),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final AnimationController controller;

  const _TopBar({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => FractionalTranslation(
        translation: Offset(0, -1 * Curves.ease.transform(controller.value)),
        child: child,
      ),
      child: TabBar(
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black26,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const <Widget>[
          Tab(child: Text('Design')),
          Tab(child: Text('Prototype')),
          Tab(child: Text('Preview')),
          Tab(child: Text('Publish')),
        ],
      ),
    );
  }
}

class _BottomBar extends StatefulWidget {
  final AnimationController controller;

  const _BottomBar({Key key, @required this.controller}) : super(key: key);

  @override
  __BottomBarState createState() => __BottomBarState();
}

class __BottomBarState extends State<_BottomBar> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, child) => FractionalTranslation(
        translation: Offset(0, Curves.ease.transform(widget.controller.value)),
        child: child,
      ),
      child: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open, size: 32),
            title: const Text(''),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_none, size: 32),
            title: const Text(''),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline, size: 32),
            title: const Text(''),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32),
            title: const Text(''),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class MockView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.search),
    );
  }
}
