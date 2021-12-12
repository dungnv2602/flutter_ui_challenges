import 'package:flutter/material.dart';
import 'common_widgets/common_widgets.dart';
import 'models.dart';
import 'text_styles.dart';

class DetailPage extends StatelessWidget {
  final Planet planet;
  const DetailPage({
    Key key,
    @required this.planet,
  })  : assert(planet != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = Container(
      child: Image.network(
        planet.picture,
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: const BoxConstraints.expand(height: 295.0),
    );

    final gradient = Container(
      margin: const EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0x00736AB7), Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.0, 1.0),
        ),
      ),
    );

    final toolbar = Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BackButton(color: Colors.white),
    );

    final content = Container(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          PlanetCard(
            planet: planet,
            axis: Axis.vertical,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'OVERVIEW',
                  style: headerTextStyle,
                ),
                const PlanetCardSeparator(),
                Text(planet.description, style: commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Container(
        color: const Color(0xFF736AB7),
        constraints: const BoxConstraints.expand(),
        child: Stack(
          children: <Widget>[
            background,
            gradient,
            content,
            toolbar,
          ],
        ),
      ),
    );
  }
}
