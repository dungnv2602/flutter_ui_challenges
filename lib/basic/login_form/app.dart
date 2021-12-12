/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// design: https://www.uplabs.com/posts/login-99a29cbb-2952-4550-a977-5081bada091d

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'form_card.dart';
import 'social_icon.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final horizontalLine = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: 60,
      height: 1.0,
      color: Colors.black26,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          /// backdrop
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset('assets/images/basic.login_form/image_01.png'),
              const Spacer(),
              Image.asset('assets/images/basic.login_form/image_02.png'),
            ],
          ),

          /// Logo
          Positioned(
            left: 0,
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/basic.login_form/logo.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  'NOVELS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    letterSpacing: 6,
                  ),
                ),
              ],
            ),
          ),

          /// form
          Positioned(
            top: 220,
            left: 28,
            right: 28,
            child: Column(
              children: <Widget>[
                FormCard(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF17ead9),
                              Color(0xFF6078ea),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6078ea).withOpacity(0.3),
                              offset: const Offset(4.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ]),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              'SIGNIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    horizontalLine,
                    const Text(
                      'Social Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    horizontalLine,
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocialIcon(
                      colors: const [
                        Color(0xFF102397),
                        Color(0xFF187adf),
                        Color(0xFF00eaf8),
                      ],
                      iconData: FontAwesomeIcons.facebookF,
                      onPressed: () {},
                    ),
                    SocialIcon(
                      colors: const [
                        Color(0xFFff355d),
                        Color(0xFFff4f38),
                      ],
                      iconData: FontAwesomeIcons.google,
                      onPressed: () {},
                    ),
                    SocialIcon(
                      colors: const [
                        Color(0xFF17ead9),
                        Color(0xFF6078ea),
                      ],
                      iconData: FontAwesomeIcons.twitter,
                      onPressed: () {},
                    ),
                    SocialIcon(
                      colors: const [
                        Color(0xFF00c6fb),
                        Color(0xFF005bea),
                      ],
                      iconData: FontAwesomeIcons.linkedin,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Discover as Guest',
                      style: TextStyle(
                        color: Color(0xFF5d74e3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
