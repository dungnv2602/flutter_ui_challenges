import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'flight_detail.dart';
import 'shared/shared.dart';

class FlightCard extends StatefulWidget {
  final int index;
  final PageController controller;

  const FlightCard({Key key, @required this.index, @required this.controller}) : super(key: key);

  @override
  _FlightCardState createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  @override
  Widget build(BuildContext context) {
    final flight = flights[widget.index];

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 120, 10, 64),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlightDetails(flight: flight, index: widget.index),
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'flight-card-${flight.id}',
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            _FlightCard(
              controller: widget.controller,
              index: widget.index,
            ),
            _FlightCardHeader(
              controller: widget.controller,
              index: widget.index,
            ),
          ],
        ),
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final int index;
  final PageController controller;

  const _FlightCard({Key key, @required this.index, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flight = flights[index];

    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          final tween = calculatePowTweenWithIndex(index: index, controller: controller, velocity: 10);
          final curve = Curves.easeInOut.transform(tween);
          final colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54).transform(curve);
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: colorTween,
                  offset: const Offset(4, 16),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: FlightImage(flight: flight),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  _FlightInfo(flight: flight),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('non-stop', style: smallGrey),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('\$', style: smallGrey),
                            Text('${flight.price}', style: bigRed),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlightCardHeader extends StatelessWidget {
  final int index;
  final PageController controller;

  const _FlightCardHeader({Key key, @required this.index, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flight = flights[index];

    return Positioned.directional(
      textDirection: TextDirection.ltr,
      top: 0,
      start: 8,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final tween = calculatePowTweenWithIndex(index: index, controller: controller, velocity: 10);
          final curve = Curves.easeInOut.transform(tween);
          return Opacity(
            opacity: curve,
            child: Transform.translate(
              offset: Offset(16 - (16 * curve), 0),
              child: HeroTextPush(
                tag: 'flight-header-${flight.id}',
                text: flight.destination,
                shrunkSize: 50,
                enlargedSize: 60,
                textStyle: flightHeader,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FlightInfo extends StatelessWidget {
  final Flight flight;

  const _FlightInfo({Key key, @required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HeroTextPush(
                      tag: 'hero-from-${flight.id}',
                      text: 'FROM',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                    HeroTextPush(
                      tag: 'hero-flight-sourcecode-${flight.id}',
                      text: flight.sourceCode,
                      shrunkSize: 40,
                      enlargedSize: 50,
                      textStyle: bigPurple,
                    ),
                    HeroTextPush(
                      tag: 'hero-flight-source-country-${flight.id}',
                      text: '${flight.source}, ${flight.sourceCountry}',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    HeroTextPush(
                      tag: 'hero-to-${flight.id}',
                      text: 'TO',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                    HeroTextPush(
                      tag: 'hero-flight-descode-${flight.id}',
                      text: flight.destinationCode,
                      shrunkSize: 40,
                      enlargedSize: 50,
                      textStyle: bigPurple,
                    ),
                    HeroTextPush(
                      tag: 'hero-flight-des-country-${flight.id}',
                      text: '${flight.destination}, ${flight.destinationCountry}',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12),
        ],
      ),
    );
  }
}
