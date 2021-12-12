/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
/// Implementation originated by: https://github.com/TechieBlossom/despicable_me_characters_app
/// With my own workarounds and improvements
/// design: https://dribbble.com/shots/6403829-Movie-Character-UI-Animation
import 'package:flutter/material.dart';

import 'list_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despicable Me Characters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.white,
        ),
      ),
      home: ListScreen(),
    );
  }
}

