/// Implementation originated by: https://github.com/devefy/Flutter-Onboarding
/// With my own workarounds and improvements
/// Source Design: https://dribbble.com/shots/6278546-Onboarding-Screens
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

import 'data.dart';
import 'page_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int currentPage = 0;

  bool lastPage = false;

  PageController pageController;

  AnimationController animationController;

  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
      if (currentPage == pageList.length - 1) {
        lastPage = true;
        animationController.forward();
      } else if (currentPage == pageList.length - 2) {
        lastPage = false;
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
                itemCount: pageList.length,
                controller: pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      final page = pageList[index];
                      double delta;
                      double dy = 1.0;

                      if (pageController.position.haveDimensions) {
                        delta = pageController.page - index;
                        print('DELTA: $delta');
                        dy = 1 - delta.abs();
                        print('dy: $dy');
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(page.imageUrl),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            height: 100,
                            child: Stack(
                              children: <Widget>[
                                Opacity(
                                  opacity: 0.1,
                                  child: GradientText(
                                    page.title,
                                    gradient: LinearGradient(colors: page.titleGradient),
                                    style: TextStyle(fontSize: 100, fontFamily: 'Montserrat-Black', letterSpacing: 2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 22, top: 30),
                                  child: GradientText(
                                    page.title,
                                    gradient: LinearGradient(colors: page.titleGradient),
                                    style: TextStyle(fontSize: 70, fontFamily: 'Montserrat-Black'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 34, top: 12),
                                  child: Transform.translate(
                                    offset: Offset(0, 100.0 * (1 - dy)),
                                    child: Text(
                                      page.body,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Montserrat-Medium',
                                        color: Color(0xFF9B9B9B),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
            Positioned(
              left: 30,
              bottom: 55,
              child: Container(
                width: 160,
                child: PageIndicator(
                  currentPage: currentPage,
                  pageCount: pageList.length,
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: 30,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: lastPage
                    ? FloatingActionButton(
                        onPressed: () {
                          /// TRANSITION TO HOME PAGE
                        },
                        backgroundColor: Colors.white70,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black54,
                        ),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
