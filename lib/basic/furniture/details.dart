/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'detail_data.dart';
import 'page_indicator.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox.fromSize(
            size: Size.fromHeight(height * 0.75),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                /// Images
                PageView.builder(
                  itemCount: furnitureDetailList.length,
                  physics:const  AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: onPageChanged,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    final data = furnitureDetailList[index];
                    return Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
                          child: Image.asset(
                            data.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 200,
                          left: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.title,
                                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data.subTitle,
                                style: TextStyle(color: Colors.black54),
                              ),
                          const     SizedBox(height: 40),
                              Text('${data.price} \$'),
                          const     SizedBox(height: 40),
                            ],
                          ),
                        ),

                        /// Page Indicator
                        Positioned(
                          top: 320,
                          left: 40,
                          child: AnimatedBuilder(
                            animation: pageController,
                            builder: (context, child) {
                              double delta;
                              double offset = 1.0;
                              if (pageController.position.haveDimensions) {
                                delta = pageController.page - index;
                                print('DELTA: $delta');
                                offset = 1 - delta.abs();
                                print('offset: $offset');
                              }
                              return Opacity(
                                opacity: offset,
                                child: PageIndicator(
                                  currentPage: currentPage,
                                  pageCount: furnitureDetailList.length,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                Positioned(
                  top: 40,
                  left: 30,
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 30,
                  left: 30,
                  right: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Wooden Armchairs',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                  const     SizedBox(height: 20),
                      Text(
                          'The Stoic approach is just one of many ideas for how to handle conflict, but there’s one element of their philosophy that feels particularly applicable in these insult-happy times. The Stoics weren’t pushovers — they just knew that not all insults were created equal. And most importantly, they knew how to decide which ones to ignore and which to take to heart.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white54],
                      begin: Alignment.center,
                      end: const  Alignment(0, 3),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius:const  BorderRadius.only(topLeft: Radius.circular(30)),
                    child: SizedBox(
                      width: 150,
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color:const  Color(0xFFfa7b58),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                color:const  Color(0xFF2a2d3f), child: Icon(Icons.shopping_basket, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
