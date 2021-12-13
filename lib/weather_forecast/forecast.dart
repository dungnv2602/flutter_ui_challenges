import 'package:flutter/material.dart';

import 'background/background_with_rings.dart';
import 'constants.dart';
import 'sliding_radial_list/index.dart';

class Forecast extends StatelessWidget {
  const Forecast({
    Key key,
    @required this.listViewModel,
    @required this.slidingRadialListController,
  })  : assert(listViewModel != null),
        assert(slidingRadialListController != null),
        super(key: key);

  final RadialListViewModel listViewModel;
  final SlidingRadialListViewController slidingRadialListController;

  Widget _temperatureText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 150, left: 10),
        child: Text(
          '68˚',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const BackgroundWithRings(),
            _temperatureText(),
            SlidingRadialListView(
              origin: Offset(centerPoint, constraints.maxHeight / 2),
              radius: radialListRadius,
              controller: slidingRadialListController,
              builder: (context, index) {
                return _RadialListItem(
                  listItemViewModel: listViewModel.items[index],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _RadialListItem extends StatelessWidget {
  const _RadialListItem({Key key, @required this.listItemViewModel})
      : assert(listItemViewModel != null),
        super(key: key);

  final RadialListItemViewModel listItemViewModel;

  static const _itemSize = 60.0;

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItemViewModel.isSelected
        ? const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          );

    final circleColor = listItemViewModel.isSelected ? const Color(0xFF6688CC) : Colors.white;

    final internalChild = Row(
      children: <Widget>[
        Container(
          width: _itemSize,
          height: _itemSize,
          decoration: circleDecoration,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image(
              image: listItemViewModel.icon,
              color: circleColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                listItemViewModel.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                listItemViewModel.subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Transform(
      transform: Matrix4.translationValues(-_itemSize / 2, -_itemSize / 2, 0),
      child: internalChild,
    );
  }
}
