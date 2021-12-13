import 'package:flutter/material.dart';

/// source: https://dribbble.com/shots/5690700-Beaches-App-animation
/// This implementation is inspired from this original code: https://github.com/lvlzeros/flutter_beaches_app, with a lot of my own tweaks.

import 'banner.dart';
import 'detail_page.dart';
import 'shared/models.dart';
import 'shared/shared.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Beach App',
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
  ValueNotifier<bool> stateNotifier;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: animationDuration);

    stateNotifier = ValueNotifier(false)
      ..addListener(() {
        if (stateNotifier.value) {
          controller.reverse(from: 1.0);
          stateNotifier.value = false;
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    stateNotifier.dispose();
    super.dispose();
  }

  void onPressed(int index) async {
    controller.forward(from: 0.0);
    final result = await Navigator.push(context, FadeInTransitionRoute(DetailPage(selectedIndex: index)));
    stateNotifier.value = result as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: controller,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: 'hero-header',
            child: AnimatedHeader(viewState: ViewState.enlarged),
            flightShuttleBuilder: (_, animation, flightDirection, __, ___) {
              return AnimatedHeader(
                  viewState: flightDirection == HeroFlightDirection.push ? ViewState.shrink : ViewState.enlarge);
            },
          ),
          SizedBox(height: 12),
          FadeTransition(
            opacity:
                Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
            child: SlideTransition(
              position: Tween(begin: Offset(0, 0), end: Offset(0, -1)).animate(controller),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 24),
                  Icon(Icons.keyboard_arrow_down),
                  SizedBox(width: 8),
                  Text(
                    'Most Visited',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: destinations.length,
            itemBuilder: (_, index) {
              return AnimatedBanner(
                index: index,
                onPressed: onPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FadeInTransitionRoute extends PageRouteBuilder {
  final Widget widget;

  FadeInTransitionRoute(this.widget)
      : super(
          pageBuilder: (_, __, ___) => widget,
          transitionDuration: animationDuration,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
}
