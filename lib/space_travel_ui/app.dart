import 'package:flutter/material.dart';

import 'common_widgets/common_widgets.dart';
import 'models.dart';

/// Implementation originated by: https://github.com/sergiandreplace/flutter_planets_tutorial
/// With my own workarounds and improvements
// design: https://www.uplabs.com/posts/space-travel-ui

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const GradientAppBar(title: 'treva'),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  PlanetCard(planet: planets[index]),
              itemCount: planets.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
