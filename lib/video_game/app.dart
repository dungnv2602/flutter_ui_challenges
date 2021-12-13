/// Implementation originated by: https://github.com/TechieBlossom/video_game_messaging_app
/// With my own workarounds and improvements
/// design: https://dribbble.com/shots/6193167-Video-Game-Message-Board-App

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_background.dart';
import 'horizontal_game_cards.dart';
import 'menu_texts.dart';
import 'models/models.dart';
import 'util/utils.dart';
// TODO fix transition back

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController cardsController;
  Animation animation;
  Animation cardsAnimation;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    cardsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    cardsAnimation = CurvedAnimation(parent: cardsController, curve: Curves.fastLinearToSlowEaseIn);

    _animate();
  }

  void _animate() async {
    await controller.forward();
    cardsController.forward();
  }

  void _handleMenuSelection(int index) async {
    await cardsController.reverse();
    setState(() {
      selectedIndex = index;
    });
    cardsController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final fab = Positioned(
      top: 36,
      right: 24,
      child: _FadeAnimatedWidget(
        controller: animation,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.apps,
            color: primaryColor,
          ),
          onPressed: () {},
        ),
      ),
    );

    final title = Positioned(
      top: 64,
      left: 36,
      child: _FadeAnimatedWidget(
        controller: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Forum', style: headingStyle),
            Text('Kick off the conversation.', style: defaultTabStyle),
          ],
        ),
      ),
    );

    final menuTexts = Transform.rotate(
      angle: -pi / 2,
      origin: Offset(90, 240),
      child: MenuTexts(
        controller: animation,
        selectedIndex: selectedIndex,
        onPressed: _handleMenuSelection,
      ),
    );

    final bottomButton = Positioned(
      bottom: 0,
      right: 0,
      left: 96,
      height: 96,
      child: SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
            .animate(CurvedAnimation(parent: controller, curve: Interval(0.9, 1.0, curve: Curves.easeOut))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(48)),
          child: FlatButton(
            onPressed: () {},
            color: primaryColor,
            child: Text('New Topic', style: buttonStyle),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(
            backgroundColor: backgroundColor,
            firstCircleColor: firstCircleColor,
            secondCircleColor: secondCircleColor,
            thirdCircleColor: thirdCircleColor,
            controller: controller,
          ),
          fab,
          title,
          menuTexts,
          bottomButton,
          Container(
            margin: EdgeInsets.only(top: 120, left: 64),
            height: 480,
            child: HorizontalGameCards(animation: cardsAnimation, forums: forumsList[selectedIndex]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    cardsController.dispose();
    super.dispose();
  }
}

class _FadeAnimatedWidget extends StatelessWidget {
  final Animation controller;
  final Widget child;

  const _FadeAnimatedWidget({Key key, @required this.controller, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Opacity(
        opacity: Curves.easeIn.transform(controller.value),
        child: child,
      ),
    );
  }
}
