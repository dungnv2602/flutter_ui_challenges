/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../weather_forecast.dart';

class SlidingRadialList extends StatelessWidget {
  final RadialListViewModel listViewModel;
  final SlidingRadialListController controller;

  const SlidingRadialList({
    Key key,
    @required this.listViewModel,
    @required this.controller,
  })  : assert(listViewModel != null),
        assert(controller != null),
        super(key: key);

  List<Widget> _radialListItems(BoxConstraints constraints) {
    final List<Widget> listItems = [];
    for (int index = 0; index < listViewModel.items.length; index++) {
      final viewModel = listViewModel.items[index];
      listItems.add(
        _radialListItem(
          viewModel,
          constraints,
          controller.getItemAngle(index),
          controller.getItemOpacity(),
        ),
      );
    }
    return listItems;
  }

  Widget _radialListItem(RadialListItemViewModel viewModel,
      BoxConstraints constraints, double angle, double opacity) {
    return Positioned(
      left: centerPoint,
      top: constraints.maxHeight / 2,
      child: RadialPosition(
        radius: baseCircleRadius + 75,
        angle: angle,
        child: Opacity(
          opacity: opacity,
          child: _RadialListItem(
            listItemViewModel: viewModel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Stack(
              fit: StackFit.expand,
              children: _radialListItems(constraints),
            );
          },
        );
      },
    );
  }
}

class _RadialListItem extends StatelessWidget {
  final RadialListItemViewModel listItemViewModel;

  const _RadialListItem({Key key, @required this.listItemViewModel})
      : assert(listItemViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItemViewModel.isSelected
        ? BoxDecoration(
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

    final circleColor =
        listItemViewModel.isSelected ? const Color(0xFF6688CC) : Colors.white;

    return Transform(
      transform: Matrix4.translationValues(-30, -30, 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  listItemViewModel.subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
