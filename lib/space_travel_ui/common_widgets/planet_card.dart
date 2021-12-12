import 'package:flutter/material.dart';
import '../common_widgets/common_widgets.dart';

import '../detail_page.dart';
import '../models.dart';
import '../text_styles.dart';

class PlanetCard extends StatelessWidget {
  final Planet planet;
  final Axis axis;
  const PlanetCard({
    Key key,
    @required this.planet,
    this.axis = Axis.horizontal,
  })  : assert(planet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: axis == Axis.horizontal
          ? () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DetailPage(planet: planet),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                ),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Stack(
          children: <Widget>[
            _Card(
              content: _Content(
                planet: planet,
                axis: axis,
              ),
              axis: axis,
            ),
            _Thumbnail(
              planet: planet,
              axis: axis,
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final _Content content;
  final Axis axis;
  const _Card({
    Key key,
    @required this.content,
    this.axis = Axis.horizontal,
  })  : assert(content != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: content,
      height: axis == Axis.horizontal ? 125.0 : 155.0,
      margin: axis == Axis.horizontal
          ? const EdgeInsets.only(left: 46.0)
          : const EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Planet planet;
  final Axis axis;
  const _Content({
    Key key,
    @required this.planet,
    this.axis = Axis.horizontal,
  })  : assert(planet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(axis == Axis.horizontal ? 76.0 : 16.0,
          axis == Axis.horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints:
          const BoxConstraints.expand(), // take as much space as possile
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),
          Text(planet.name, style: titleTextStyle),
          const SizedBox(height: 10),
          Text(planet.location, style: commonTextStyle),
          const PlanetCardSeparator(),
          Row(
            children: <Widget>[
              Expanded(
                flex: axis == Axis.horizontal ? 1 : 0,
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/space_travel_ui/ic_distance.png',
                        height: 12),
                    const SizedBox(width: 8),
                    Text(planet.distance, style: smallTextStyle),
                  ],
                ),
              ),
              SizedBox(width: axis == Axis.horizontal ? 8 : 32),
              Expanded(
                flex: axis == Axis.horizontal ? 1 : 0,
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/space_travel_ui/ic_gravity.png',
                        height: 12),
                    const SizedBox(width: 8),
                    Text(planet.gravity, style: smallTextStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final Planet planet;
  final Axis axis;
  const _Thumbnail({
    Key key,
    @required this.planet,
    this.axis = Axis.horizontal,
  })  : assert(planet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: axis == Axis.horizontal
          ? FractionalOffset.centerLeft
          : FractionalOffset.center,
      child: Hero(
        tag: 'planet-thumbnail-${planet.id}',
        child: Image(
          image: AssetImage(planet.image),
          height: 92.0,
          width: 92.0,
        ),
      ),
    );
  }
}
