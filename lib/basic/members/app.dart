/// Implementation originated by: https://github.com/TechieBlossom/palette_generator_demo
/// With my own workarounds and improvements
/// Source: https://dribbble.com/shots/5788331-Our-Team-Mobile-Version

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'team_members_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: TeamMembersPage(),
    );
  }
}
