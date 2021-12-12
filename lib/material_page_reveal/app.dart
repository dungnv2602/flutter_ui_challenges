/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/// design: https://github.com/Ramotion/paper-onboarding-android
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements
///
import 'dart:async';

import 'package:flutter/material.dart';

import 'material_page_reveal.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MaterialPageReveal(
        pages: pages,
      ),
    );
  }
}

class MaterialPageReveal extends StatefulWidget {
  final List<PageViewModel> pages;

  const MaterialPageReveal({Key key, @required this.pages})
      : assert(pages != null),
        super(key: key);
  @override
  _MaterialPageRevealState createState() => _MaterialPageRevealState();
}

class _MaterialPageRevealState extends State<MaterialPageReveal>
    with TickerProviderStateMixin {
  PageDraggerAnimationController animationController;

  StreamController<SlideUpdate> slideUpdateStream;

  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0;

  int currentPageIndex = 0;
  int nextPageIndex = 0;

  @override
  void initState() {
    super.initState();
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate slideUpdate) {
      setState(() {
        if (slideUpdate.type == SlideUpdateType.dragging) {
          _onDragging(slideUpdate);
        } else if (slideUpdate.type == SlideUpdateType.doneDragging) {
          _onDoneDragging(slideUpdate);
        } else if (slideUpdate.type == SlideUpdateType.doneAnimating) {
          _onDoneAnimating(slideUpdate);
        }
        // update values
        slideDirection = slideUpdate.direction;
        slidePercent = slideUpdate.slidePercent;
      });
    });
  }

  void _onDragging(SlideUpdate slideUpdate) {
    if (slideDirection == SlideDirection.leftToRight) {
      nextPageIndex = currentPageIndex - 1;
    } else if (slideDirection == SlideDirection.rightToLeft) {
      nextPageIndex = currentPageIndex + 1;
    } else {
      nextPageIndex = currentPageIndex;
    }
  }

  void _onDoneDragging(SlideUpdate slideUpdate) {
    TransitionGoal goal;
    // if slidePercent is > 0.5 => animate to next page
    if (slidePercent > 0.5) {
      goal = TransitionGoal.open;
      // else => animate back to origin
    } else {
      goal = TransitionGoal.close;
      nextPageIndex = currentPageIndex;
    }
    animationController = PageDraggerAnimationController(
      transitionGoal: goal,
      slideDirection: slideDirection,
      slidePercent: slidePercent,
      slideUpdateStream: slideUpdateStream,
      vsync: this,
    )..run();
  }

  void _onDoneAnimating(SlideUpdate slideUpdate) {
    animationController.dispose();
    animationController = null;

    currentPageIndex = nextPageIndex;
  }

  @override
  void dispose() {
    slideUpdateStream.close();
    slideUpdateStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            percentVisible: 1,
            viewModel: widget.pages[currentPageIndex],
          ),
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              percentVisible: slidePercent,
              viewModel: widget.pages[nextPageIndex],
            ),
          ),
          PageIndicators(
            indicatorViewModel: PageIndicatorsViewModel(
              pages: widget.pages,
              currentPageIndex: currentPageIndex,
              slideDirection: slideDirection,
              slidePercent: slidePercent,
            ),
          ),
          PageDragger(
            slideUpdateStream: slideUpdateStream,
            canDragLeftToRight: currentPageIndex > 0,
            canDragRightToLeft: currentPageIndex < widget.pages.length - 1,
          ),
        ],
      ),
    );
  }
}

final pages = [
  PageViewModel(
    color: const Color(0xFF9B90BC),
    image: Image.asset('assets/images/page_reveal/stores.png',
        width: 200, height: 200),
    title: Text(
      'Store',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    body: Text(
      'All local stores are categorized for your convenience',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  ),
  PageViewModel(
    color: const Color(0xFF678FB4),
    image: Image.asset('assets/images/page_reveal/hotels.png',
        width: 250, height: 250),
    title: Text(
      'Hotels',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    body: Text(
      'All hotels and hostels are sorted by hospitality rating',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
    indicatorIcon: Image.asset(
      'assets/images/page_reveal/key.png',
      color: const Color(0xFF678FB4),
    ),
  ),
  PageViewModel(
    color: const Color(0xFF65B0B4),
    image: Image.asset('assets/images/page_reveal/banks.png',
        width: 300, height: 300),
    title: Text(
      'Banks',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    body: Text(
      'We carefully verify all banks before adding them into the app',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  ),
];
