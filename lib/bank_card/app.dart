/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

// design: https://dribbble.com/shots/5551358-Day11-Animated-Financial-Bank-Card
// heavily inspired by this implementation: https://github.com/fdoyle/flutter_demo_bank_card
import 'package:flutter/material.dart';

import 'cards_section.dart';
import 'models.dart';

/// design: https://dribbble.com/shots/5551358-Day11-Animated-Financial-Bank-Card
/// Implementation originated by: https://github.com/fdoyle/flutter_demo_bank_card
/// With my own workarounds and improvements

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3671),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderSection(),
            Expanded(child: CardsSection(cards: cards)),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        'assets/images/bank_card/credit-card.png',
                        fit: BoxFit.cover,
                        width: 15,
                        height: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Design Crypto'),
                  ],
                ),
              ),
              Icon(Icons.menu),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: <Widget>[
              Center(
                child: Text(
                  'Please Add',
                  style: TextStyle(
                    fontSize: 46,
                    color: Colors.white.withAlpha(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                bottom: 0,
                start: 0,
                end: 0,
                child: Center(
                  child: Text(
                    'Credit Card',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Image.asset(
            'assets/images/bank_card/credit-card.png',
            fit: BoxFit.cover,
            height: 25,
            width: 25,
          ),
          const SizedBox(height: 8),
          Text(
            'OnePay',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Invest in your\nfuture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withAlpha(150),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
