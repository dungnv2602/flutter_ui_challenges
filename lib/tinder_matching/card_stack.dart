/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'draggable_card.dart';
import 'match_engine.dart';
import 'profile_card.dart';
import 'tinder_engine.dart';

class CardStack extends StatefulWidget {
  const CardStack({
    @required this.matchEngine,
    @required this.tinderEngine,
  })  : assert(matchEngine != null),
        assert(tinderEngine != null);

  final MatchEngine matchEngine;

  final TinderEngine tinderEngine;

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  double _nextCardScale = 0.9;

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    final currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        break;
      case SlideDirection.right:
        currentMatch.like();
        break;
      case SlideDirection.up:
        currentMatch.superLike();
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // back card
        DraggableCard(
          isDraggable: false,
          card: Transform(
            transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
            alignment: Alignment.center,
            child: ProfileCard(profile: widget.matchEngine.nextMatch.profile),
          ),
        ),

        // front card
        DraggableCard(
          tinderEngine: widget.tinderEngine,
          onSlideUpdate: _onSlideUpdate,
          onSlideOutComplete: _onSlideOutComplete,
          card: ProfileCard(
            key: _frontCard,
            profile: widget.matchEngine.currentMatch.profile,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);
    _assignFrontCardKeyToCurrentMatch();
  }

  void _assignFrontCardKeyToCurrentMatch() {
    // use this key to differentiate the front card with the back card
    // which use the same widget DraggableCard
    // so that the system can render UI properly
    _frontCard = Key(widget.matchEngine.currentMatch.profile.name);
  }

  void _onMatchEngineChange() {
    // reassign key
    _assignFrontCardKeyToCurrentMatch();
    // re-render
    setState(() {});
  }

  @override
  void dispose() {
    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
    }
  }
}
