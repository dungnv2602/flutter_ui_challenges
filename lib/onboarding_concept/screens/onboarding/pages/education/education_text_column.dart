import 'package:flutter/material.dart';

import '../../widgets/index.dart';

class EducationTextColumn extends StatelessWidget {
  const EducationTextColumn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextColumn(
      title: 'Keep learning',
      body: 'Ipsum magna enim cupidatat culpa elit cillum velit occaecat.',
    );
  }
}
