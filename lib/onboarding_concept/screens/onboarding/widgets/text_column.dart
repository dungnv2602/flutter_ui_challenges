import 'package:flutter/material.dart';

import '../../../constants.dart';

class TextColumn extends StatelessWidget {
  const TextColumn({
    @required this.title,
    @required this.body,
  })  : assert(title != null),
        assert(body != null);

  final String body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline5.copyWith(color: kWhite, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: kSpaceS),
        Text(
          body,
          style: Theme.of(context).textTheme.subtitle1.copyWith(color: kWhite),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
