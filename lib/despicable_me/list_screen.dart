/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'character_widget.dart';
import 'models.dart';
import 'util.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 8),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Despicable Me', style: TextUtils.display1),
                  const   TextSpan(text: '\n'),
                    TextSpan(text: 'Characters', style: TextUtils.display2),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics:const  BouncingScrollPhysics(),
                controller: _controller,
                children: characters
                    .map((item) => CharacterWidget(
                          character: item,
                          pageController: _controller,
                          currentPage: characters.indexOf(item),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
