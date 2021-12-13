/// design: https://dribbble.com/shots/3898209-iPhone-X-Social-App

// todo fix error begin

import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'bottom_nav_bar.dart';
import 'models.dart';
import 'profile_info_bottom_sheet.dart';
import 'profile_info_row.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation heightFractionAnimation;

  PageController pageController = PageController();

  double get maxHeight => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    heightFractionAnimation = Tween(begin: 0.78, end: 0.45).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTap() async {
    final bool isCompleted = controller.status == AnimationStatus.completed;
    controller.fling(velocity: isCompleted ? -2 : 2);
  }

  void dragUpdate(DragUpdateDetails details) {
    controller.value -= details.primaryDelta / (maxHeight ?? details.primaryDelta);
  }

  void dragEnd(DragEndDetails details) {
    if (controller.isAnimating || controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      controller.fling(velocity: max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      controller.fling(velocity: min(-2.0, -flingVelocity));
    else
      controller.fling(velocity: controller.value < 0.5 ? -2.0 : 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, child) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: heightFractionAnimation.value,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  PageView.builder(
                    controller: pageController,
                    physics: const ClampingScrollPhysics(),
                    pageSnapping: true,
                    itemCount: profiles.length,
                    itemBuilder: (_, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(profiles[index].imgPath, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black12,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  FractionalTranslation(
                    translation: const Offset(0, -1),
                    child: PageViewTransition(
                      controller: pageController,
                      itemBuilder: (_, index) => ProfileInfoRow(index: index),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTap,
              onVerticalDragUpdate: dragUpdate,
              onVerticalDragEnd: dragEnd,
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 1.05 - heightFractionAnimation.value,
                child: AnimatedBottomSheet(controller: pageController),
              ),
            ),
            child,
          ],
        ),
        child: BottomNavBar(),
      ),
    );
  }
}

class AnimatedBottomSheet extends StatelessWidget {
  final PageController controller;

  const AnimatedBottomSheet({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -10),
            blurRadius: 20,
          ),
        ],
        color: const Color(0xFFeeeeee),
      ),
      child:
          PageViewTransition(controller: controller, itemBuilder: (_, index) => ProfileInfoBottomSheet(index: index)),
    );
  }
}

class PageViewTransition extends StatelessWidget {
  final PageController controller;
  final IndexedWidgetBuilder itemBuilder;

  const PageViewTransition({Key key, @required this.controller, @required this.itemBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final currentPage = calculateCurrentPage(controller);

        final opacityTween = calculateTween(controller: controller, velocity: 5.0);
        final translateTween = calculateTween(controller: controller, velocity: 1.0);

        return Opacity(
          opacity: opacityTween,
          child: Transform.translate(
            offset: Offset(0, 100 - (100 * translateTween)),
            child: itemBuilder(context, currentPage.round()),
          ),
        );
      },
    );
  }
}
