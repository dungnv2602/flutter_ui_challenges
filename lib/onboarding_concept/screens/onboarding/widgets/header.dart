import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../widgets/logo.dart';

class Header extends StatelessWidget {
  const Header({
    @required this.onSkip,
  }) : assert(onSkip != null);

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Logo(
          color: kWhite,
          size: 32.0,
        ),
        GestureDetector(
          onTap: onSkip,
          child: Text(
            'Skip',
            style: Theme.of(context).textTheme.subtitle1.copyWith(color: kWhite),
          ),
        ),
      ],
    );
  }
}
