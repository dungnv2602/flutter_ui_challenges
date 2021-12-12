/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'shared/models.dart';
import 'shared/shared.dart';

class DetailPage extends StatefulWidget {
  final int selectedIndex;

  const DetailPage({Key key, @required this.selectedIndex}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  double get width => MediaQuery.of(context).size.width;

  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: animationDuration);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void pop() {
    controller.reverse();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final model = destinations[widget.selectedIndex];
    return WillPopScope(
      onWillPop: () {
        pop();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: pop,
          ),
          actions: <Widget>[
            ScaleTransition(
              scale: curve,
              child: IconButton(
                icon: Icon(
                  Icons.cloud_queue,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: pop,
                child: Hero(
                  tag: 'hero-header',
                  child: AnimatedHeader(
                    viewState: ViewState.shrunk,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              child: Hero(
                tag: 'img-${model.id}',
                child: Image.asset(
                  model.imgAssetsPath[0],
                  fit: BoxFit.cover,
                  width: width * 0.9,
                  height: 400,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: width * 0.1,
              child: Hero(
                tag: 'button-${model.id}',
                child: BeveledRectangleButton(
                  onPressed: () {},
                  iconData: Icons.add,
                  iconColor: Colors.white,
                  buttonColor: Colors.black,
                  buttonSize: 60,
                ),
              ),
            ),
            Positioned(
              top: 415,
              left: 36,
              child: Hero(
                tag: 'title-${model.id}',
                child: AnimatedTitle(
                  title: model.title,
                  viewState: ViewState.enlarged,
                ),
              ),
            ),
            Positioned(
              top: 500,
              left: 36,
              right: width * 0.2,
              child: Hero(
                tag: 'details-${model.id}',
                child: AnimatedDetails(
                  model: model,
                  viewState: ViewState.enlarged,
                ),
              ),
            ),
            SlideTransition(
              position: Tween(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(curve),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BeveledRectangleButton(
                      onPressed: () {},
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      buttonColor: Colors.black,
                      buttonSize: 60,
                    ),
                    BeveledRectangleButton(
                      onPressed: () {},
                      iconData: Icons.arrow_forward_ios,
                      iconColor: Colors.white,
                      buttonColor: Colors.black,
                      buttonSize: 60,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
