import 'package:flutter/material.dart';

import 'shared/models.dart';
import 'shared/shared.dart';

class AnimatedBanner extends StatelessWidget {
  final int index;
  final ValueChanged<int> onPressed;

  const AnimatedBanner({Key key, @required this.index, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = destinations[index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: 'details-${model.id}',
                    child: AnimatedDetails(
                      model: model,
                      viewState: ViewState.shrunk,
                    ),
                    flightShuttleBuilder: (_, animation, flightDirection, __, ___) {
                      return AnimatedDetails(
                        model: model,
                        viewState: flightDirection == HeroFlightDirection.push ? ViewState.enlarge : ViewState.shrink,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => onPressed(index),
                    child: Hero(
                      tag: 'img-${model.id}',
                      child: Image.asset(
                        model.imgAssetsPath[0],
                        fit: BoxFit.cover,
                        height: 60,
                        width: 180,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    width: 80,
                    child: Hero(
                      tag: 'title-${model.id}',
                      child: AnimatedTitle(
                        title: model.title,
                        viewState: ViewState.shrunk,
                      ),
                      flightShuttleBuilder: (context, animation, flightDirection, fromHeroContext, toHeroContext) {
                        return AnimatedTitle(
                          title: model.title,
                          isOverflow: true,
                          viewState: flightDirection == HeroFlightDirection.push ? ViewState.enlarge : ViewState.shrink,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Hero(
            tag: 'button-${model.id}',
            child: BeveledRectangleButton(
              onPressed: () {},
              iconData: Icons.add,
              iconColor: Colors.white,
              buttonColor: Colors.black,
              buttonSize: 60,
            ),
          ),
        ],
      ),
    );
  }
}
