import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

class ForecastAppBar extends StatelessWidget {
  const ForecastAppBar({Key key, @required this.selectedIndexDate, @required this.onDrawerArrowTap})
      : assert(selectedIndexDate != null),
        assert(onDrawerArrowTap != null),
        super(key: key);

  final VoidCallback onDrawerArrowTap;
  final ValueNotifier<int> selectedIndexDate;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: selectedIndexDate,
            builder: (_, __) => AnimatedSpinner(
              child: Text(_weatherForecastDates[selectedIndexDate.value]),
            ),
          ),
          const Text(
            'Sacramento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 35,
          ),
          onPressed: onDrawerArrowTap,
        ),
      ],
    );
  }
}

const _weatherForecastDates = [
  'Monday, August 28',
  'Tuesday, August 29',
  'Wednesday, August 30',
  'Thursday, August 30',
  'Friday, September 01',
  'Saturday, August 02',
  'Sunday, August 03',
];
