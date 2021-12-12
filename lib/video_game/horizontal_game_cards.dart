/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'models/models.dart';
import 'util/utils.dart';

class HorizontalGameCards extends StatelessWidget {
  final List<Forum> forums;
  final Animation animation;

  const HorizontalGameCards({
    Key key,
    @required this.animation,
    @required this.forums,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: ListView.builder(
            itemCount: forums.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (_, index) => _GameCard(
                  forum: forums[index],
                  index: index,
                )),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Forum forum;
  final int index;

  const _GameCard({Key key, @required this.forum, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => GameDetailPage(forum: forum, index: index))),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          elevation: 24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: 'img-${forum.title}-$index',
                  child: Image.asset(
                    forum.imagePath,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _GameCardDetails(forum: forum),
                ),
                Positioned(
                  left: 0,
                  bottom: 80.0,
                  child: _GameCardName(forum: forum),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCardName extends StatelessWidget {
  final Forum forum;

  const _GameCardName({Key key, @required this.forum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      elevation: 20.0,
      shape: _GameCardNameShapeBorder(),
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 20.0, right: 16.0, bottom: 5.0),
        child: Text(forum.title, style: forumNameTextStyle),
      ),
    );
  }
}

class _GameCardDetails extends StatelessWidget {
  final Forum forum;

  const _GameCardDetails({Key key, @required this.forum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _GameCardDetailsClipper(),
      child: Container(
        height: 180.0,
        padding: const EdgeInsets.only(left: 20.0, right: 16.0, top: 24.0, bottom: 12.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2.0),
                    ),
                    height: 40.0,
                    width: 40.0,
                    child: Center(child: Text(forum.rank, style: rankStyle)),
                  ),
                  Text('new', style: labelTextStyle),
                ],
              ),
            ),
            SizedBox(height: 20),
            StatisticsRow(
              forum: forum,
              labelTextStyle: labelTextStyle,
              valueTextStyle: valueTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsRow extends StatelessWidget {
  final Forum forum;
  final TextStyle labelTextStyle;
  final TextStyle valueTextStyle;

  const StatisticsRow({Key key, @required this.forum, @required this.labelTextStyle, @required this.valueTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _StatisticsWidget(
          value: forum.topics.length.toString(),
          label: 'topics',
          labelStyle: labelTextStyle,
          valueStyle: valueTextStyle,
        ),
        _StatisticsWidget(
          value: forum.threads,
          label: 'threads',
          labelStyle: labelTextStyle,
          valueStyle: valueTextStyle,
        ),
        _StatisticsWidget(
          value: forum.subs,
          label: 'subs',
          labelStyle: labelTextStyle,
          valueStyle: valueTextStyle,
        ),
      ],
    );
  }
}

class _StatisticsWidget extends StatelessWidget {
  final String label, value;
  final TextStyle labelStyle, valueStyle;

  _StatisticsWidget({this.label, this.value, this.labelStyle, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(value, style: valueStyle),
        Text(label, style: labelStyle),
      ],
    );
  }
}

class _GameCardNameShapeBorder extends ShapeBorder {
  final double distance = 12;
  final double controlPoint = 2;

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(Size(130.0, 60.0));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null;
  }

  Path getClip(Size size) {
    Path clippedPath = Path();
    clippedPath.moveTo(distance, 0);
    clippedPath.quadraticBezierTo(controlPoint, controlPoint, 0, distance);
    clippedPath.lineTo(0, size.height - distance);
    clippedPath.quadraticBezierTo(controlPoint, size.height - controlPoint, distance, size.height);
    clippedPath.lineTo(size.width - distance, size.height);
    clippedPath.quadraticBezierTo(
        size.width - controlPoint, size.height - controlPoint, size.width, size.height - distance);
    clippedPath.lineTo(size.width, size.height * 0.6);
    clippedPath.quadraticBezierTo(
        size.width - 1, size.height * 0.6 - distance, size.width - distance, size.height * 0.6 - distance - 3);
    clippedPath.lineTo(distance + 6, 0);
    clippedPath.close();
    return clippedPath;
  }
}

class _GameCardDetailsClipper extends CustomClipper<Path> {
  final double distance = 12;
  final double controlPoint = 2;

  @override
  Path getClip(Size size) {
    final double height = size.height;
    final double halfHeight = size.height * 0.5;
    final double width = size.width;

    Path clippedPath = Path();
    clippedPath.moveTo(0, halfHeight);
    clippedPath.lineTo(0, height - distance);
    clippedPath.quadraticBezierTo(controlPoint, height - controlPoint, distance, height);
    clippedPath.lineTo(width, height);
    clippedPath.lineTo(width, 30.0);
    clippedPath.quadraticBezierTo(width - 5, 5.0, width - 35, 15.0);
    clippedPath.close();
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
