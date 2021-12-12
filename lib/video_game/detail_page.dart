/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'app_background.dart';
import 'horizontal_game_cards.dart' show StatisticsRow;
import 'models/models.dart';
import 'util/utils.dart';

class GameDetailPage extends StatefulWidget {
  final Forum forum;
  final int index;

  const GameDetailPage({Key key, @required this.forum, @required this.index}) : super(key: key);

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController bottomController;
  Animation fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    bottomController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    _animate();
  }

  void _animate() async {
    await controller.forward();
    bottomController.forward();
  }

  Future<void> _reverse() async {
    await bottomController.reverse();
    await controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(
            backgroundColor: backgroundColor,
            firstCircleColor: firstOrangeCircleColor,
            secondCircleColor: secondOrangeCircleColor,
            thirdCircleColor: thirdOrangeCircleColor,
            controller: controller,
          ),
          Positioned(
            top: 24,
            left: 14,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: IconButton(
                onPressed: () async {
                  await _reverse();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 84,
            left: 28,
            right: 100,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: StatisticsRow(
                forum: widget.forum,
                labelTextStyle: whiteLabelTextStyle,
                valueTextStyle: whiteValueTextStyle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Hero(
              tag: 'img-${widget.forum.title}-${widget.index}',
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                child: Image.asset(widget.forum.imagePath, fit: BoxFit.cover),
              ),
            ),
          ),
          BottomSheet(forum: widget.forum, animation: controller),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class BottomSheet extends StatelessWidget {
  final Forum forum;
  final Animation animation;
  final Animation scaleAnimation;
  final Animation offsetAnimation;

  BottomSheet({Key key, @required this.forum, @required this.animation})
      : scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Interval(0.8, 1.0, curve: Curves.elasticOut))),
        offsetAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
            .animate(CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                gradient: LinearGradient(
                  colors: [Colors.white, backgroundColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Topics", style: subHeadingStyle),
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          TopicsTile(topic: forum.topics[0]),
                          TopicsTile(topic: forum.topics[1]),
                          TopicsTile(topic: forum.topics[0]),
                          TopicsTile(topic: forum.topics[1]),
                          TopicsTile(topic: forum.topics[0]),
                          TopicsTile(topic: forum.topics[1]),
                          TopicsTile(topic: forum.topics[0]),
                          TopicsTile(topic: forum.topics[1]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: 24,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Text(forum.rank, style: rankStyle),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopicsTile extends StatelessWidget {
  final Topic topic;

  TopicsTile({this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              topic.question,
              style: topicQuestionTextStyle,
            ),
            Container(
              width: 50,
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryColor,
              ),
              child: Text(
                topic.answerCount,
                style: topicAnswerCountTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Text(
            topic.recentAnswer,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: topicAnswerTextStyle,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
