/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import '../utils/utils.dart';

import 'shared/shared.dart';

class FlightDetails extends StatefulWidget {
  final int index;
  final Flight flight;

  const FlightDetails({Key key, @required this.flight, @required this.index}) : super(key: key);

  @override
  _FlightDetailsState createState() => _FlightDetailsState();
}

class _FlightDetailsState extends State<FlightDetails> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pop(BuildContext context) async {
    await _controller.reverse();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(tag: 'flight-card-${widget.flight.id}', child: Container()),
          Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    FlightImage(flight: widget.flight),
                    _TopAppBar(onPressed: () => _pop(context)),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: _FlightInfoColumn(
                  flight: widget.flight,
                  controller: _controller,
                ),
              )
            ],
          ),
          _MaskedHeader(flight: widget.flight),
        ],
      ),
    );
  }
}

class _FlightInfoColumn extends StatelessWidget {
  final Flight flight;
  final AnimationController controller;

  const _FlightInfoColumn({Key key, @required this.flight, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(width: double.infinity, child: _FlightInfo(flight: flight)),
        Expanded(child: _InfoColumn(flight: flight, controller: controller)),
      ],
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
                    HeroTextPushed(
                      tag: 'hero-from-${flight.id}',
                      text: 'FROM',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                    HeroTextPushed(
                      tag: 'hero-flight-sourcecode-${flight.id}',
                      text: flight.sourceCode,
                      shrunkSize: 40,
                      enlargedSize: 50,
                      textStyle: bigPurple,
                    ),
                    HeroTextPushed(
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
                    HeroTextPushed(
                      tag: 'hero-to-${flight.id}',
                      text: 'TO',
                      shrunkSize: 12,
                      enlargedSize: 14,
                      textStyle: smallPurple,
                    ),
                    HeroTextPushed(
                      tag: 'hero-flight-descode-${flight.id}',
                      text: flight.destinationCode,
                      shrunkSize: 40,
                      enlargedSize: 50,
                      textStyle: bigPurple,
                    ),
                    HeroTextPushed(
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

class _InfoColumn extends StatefulWidget {
  final Flight flight;
  final AnimationController controller;

  const _InfoColumn({Key key, @required this.flight, @required this.controller}) : super(key: key);

  @override
  __InfoColumnState createState() => __InfoColumnState();
}

class __InfoColumnState extends State<_InfoColumn> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _InfoRow(
            animation: CurveTween(curve: Interval(0.0, 1.0, curve: Curves.easeInOut)).animate(widget.controller),
            leftInfoWidget: _LeftInfoWidget(
              iconData: Icons.fingerprint,
              title: 'PAYMENT',
              subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            rightInfoWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '\$',
                  style: smallGrey,
                ),
                Text('${widget.flight.price}', style: bigRed),
              ],
            ),
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12),
          _InfoRow(
            animation: CurveTween(curve: Interval(0.2, 1.0, curve: Curves.easeInOut)).animate(widget.controller),
            leftInfoWidget: _LeftInfoWidget(
              iconData: Icons.calendar_today,
              title: 'DATE',
              subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            rightInfoWidget: Row(
              children: <Widget>[
          const       Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('01 - 30', style: flightInfoRightValue),
                    Text('September', style: smallGrey),
                  ],
                ),
              ],
            ),
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12),
          _InfoRow(
            animation: CurveTween(curve: Interval(0.4, 1.0, curve: Curves.easeInOut)).animate(widget.controller),
            leftInfoWidget: _LeftInfoWidget(
              iconData: Icons.airline_seat_recline_extra,
              title: 'CABIN',
              subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            rightInfoWidget: Row(
              children: <Widget>[
        const         Spacer(),
                Text('economy', style: flightInfoRightValue),
              ],
            ),
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12),
          _InfoRow(
            animation: CurveTween(curve: Interval(0.6, 1.0, curve: Curves.easeInOut)).animate(widget.controller),
            leftInfoWidget: _LeftInfoWidget(
              iconData: Icons.flight,
              title: 'FLIGHT PATH',
              subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            rightInfoWidget: Row(
              children: <Widget>[
          const       Spacer(),
                Text('1500km', style: flightInfoRightValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Widget leftInfoWidget;
  final Widget rightInfoWidget;
  final Animation animation;

  const _InfoRow({Key key, @required this.leftInfoWidget, @required this.rightInfoWidget, @required this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          final offset = 1 - animation.value;
          return Row(
            children: <Widget>[
              Expanded(
                child: Opacity(
                  opacity: animation.value,
                  child: Transform.translate(
                    child: leftInfoWidget,
                    offset: Offset(0.25 * width * offset, 0),
                  ),
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: animation.value,
                  child: Transform.translate(
                    child: rightInfoWidget,
                    offset: Offset(-0.25 * width * offset, 0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LeftInfoWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;

  const _LeftInfoWidget({Key key, this.iconData, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(iconData, size: 32, color: redPink),
     const    SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: flightInfoTitle),
              Text(subtitle, style: smallGrey),
            ],
          ),
        )
      ],
    );
  }
}

class _MaskedHeader extends StatelessWidget {
  final Flight flight;

  const _MaskedHeader({Key key, @required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:const  Alignment(0, -0.9),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Colors.white,
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        child: HeroTextPushed(
          tag: 'flight-header-${flight.id}',
          text: flight.destination,
          shrunkSize: 50,
          enlargedSize: 60,
          textStyle: flightHeader,
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  final VoidCallback onPressed;

  const _TopAppBar({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18, color: Colors.white.withOpacity(0.8)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
