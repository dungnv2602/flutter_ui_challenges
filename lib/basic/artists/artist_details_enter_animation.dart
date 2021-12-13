import 'package:flutter/material.dart';

class ArtistDetailsEnterAnimation {
  final AnimationController controller;
  final Animation<double> backdropOpacity;
  final Animation<double> backdropBlur;
  final Animation<double> avatarSize;
  final Animation<double> nameOpacity;
  final Animation<double> locationOpacity;
  final Animation<double> dividerWidth;
  final Animation<double> biographyOpacity;
  final Animation<double> videoScrollerXTranslation;
  final Animation<double> videoScrollerOpacity;

  ArtistDetailsEnterAnimation({this.controller})
      : backdropOpacity = Tween<double>(begin: 0.5, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        backdropBlur = Tween<double>(begin: 0, end: 5).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        avatarSize = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              0.4,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        nameOpacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.35,
              0.45,
              curve: Curves.easeIn,
            ),
          ),
        ),
        locationOpacity = Tween<double>(begin: 0, end: 0.85).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.5,
              0.6,
              curve: Curves.easeIn,
            ),
          ),
        ),
        dividerWidth = Tween<double>(begin: 0, end: 225).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.65,
              0.75,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        biographyOpacity = Tween<double>(begin: 0, end: 0.85).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.75,
              0.9,
              curve: Curves.easeIn,
            ),
          ),
        ),
        videoScrollerXTranslation = Tween<double>(begin: 60, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.83,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        videoScrollerOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(
            0.83,
            1,
            curve: Curves.fastOutSlowIn,
          ),
        ));
}
