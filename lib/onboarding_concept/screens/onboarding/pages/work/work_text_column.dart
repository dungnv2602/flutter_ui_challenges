import 'package:flutter/material.dart';

import '../../widgets/index.dart';

class WorkTextColumn extends StatelessWidget {
  const WorkTextColumn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextColumn(
      title: 'Work together',
      body: 'Adipisicing anim ex excepteur duis quis in tempor eu ullamco adipisicing.',
    );
  }
}
