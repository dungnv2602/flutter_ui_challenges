import 'package:flutter/material.dart';

import 'sections_organizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Section Organizer',
      home: SectionsOrganizer(),
    );
  }
}
