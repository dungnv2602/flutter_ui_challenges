/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'shared.dart';

class CardView extends StatelessWidget {
  final PageController controller;
  final int index;
  final XdModel model;

  CardView({Key key, @required this.controller, @required this.index})
      : model = models[index],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final imageTween = calculateTweenWithIndex(index: index, controller: controller);
        final translateTween = calculateTranslateGaussTweenWithIndex(index: index, controller: controller);
        final alignTween = calculateGaussTweenWithIndex(index: index, controller: controller);

        return Container(
          transform: Matrix4.translationValues(translateTween, 0, 0),
          child: LayoutBuilder(
            builder: (_, constraints) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: <Widget>[
                  BackgroundHero(
                    model: model,
                    imageTween: imageTween,
                  ),
                  TitleHero(
                    model: model,
                    alignTween: alignTween,
                  ),
                  SubtitleHero(
                    model: model,
                    alignTween: alignTween,
                  ),
                  Positioned(
                    bottom: constraints.maxHeight * 0.2,
                    left: constraints.maxWidth * 0.5,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, 0),
                      child: Hero(
                        tag: 'hero-avatar-${model.title}',
                        child: AvatarWidget(model: model),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 96),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, 8),
                blurRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }
}

class BackgroundHero extends StatelessWidget {
  final XdModel model;
  final double imageTween;

  const BackgroundHero({Key key, @required this.model, @required this.imageTween}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'hero-bgrd-${model.title}',
      child: Column(
        children: <Widget>[
          Expanded(
            child: FractionalTranslation(
              translation: Offset(0.2 - 0.2 * imageTween, 0),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Image.asset(
                  model.backgroundImgPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 110,
          ),
        ],
      ),
      flightShuttleBuilder: (_, animation, __, fromContext, toContext) {
        final Hero toHero = toContext.widget;
        return ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            ),
          ),
          child: toHero.child,
        );
      },
    );
  }
}

class TitleHero extends StatelessWidget {
  final XdModel model;
  final double alignTween;

  const TitleHero({Key key, @required this.model, @required this.alignTween}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 48,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(-16 * alignTween, 0),
          child: HeroTextPush(
            tag: 'hero-title-${model.title}',
            text: model.title,
            shrunkSize: 24,
            enlargedSize: 32,
            textStyle: titleStyle,
          ),
        ),
      ),
    );
  }
}

class SubtitleHero extends StatelessWidget {
  final XdModel model;
  final double alignTween;

  const SubtitleHero({Key key, @required this.model, @required this.alignTween}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(-16 * alignTween, 0),
          child: HeroTextPush(
            tag: 'hero-collabs-${model.title}',
            text: '${model.collabs} collaborators',
            shrunkSize: 12,
            enlargedSize: 14,
            textStyle: subtitleStyle,
          ),
        ),
      ),
    );
  }
}
