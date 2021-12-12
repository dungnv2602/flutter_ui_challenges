import 'dart:async';

import 'package:flutter/material.dart';
import '../ticket_page/air_asia_ticket_page.dart';
import 'air_asia_flight_stop_card.dart';
import 'common.dart';

class AirAsiaPriceTab extends StatefulWidget {
  const AirAsiaPriceTab({Key key, this.height, this.onPlaneFlightStart}) : super(key: key);

  final double height;
  final VoidCallback onPlaneFlightStart;

  @override
  _AirAsiaPriceTabState createState() => _AirAsiaPriceTabState();
}

class _AirAsiaPriceTabState extends State<AirAsiaPriceTab> with TickerProviderStateMixin {
  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  AnimationController _dotsAnimationController;
  AnimationController _fabAnimationController;
  Animation<double> _planeSizeAnimation;
  Animation<double> _planeTravelAnimation;
  Animation<double> _fabAnimation;
  final List<Animation<double>> _dotsPositionAnimation = [];

  static const List<AirAsiaFlightStop> _flightStops = [
    AirAsiaFlightStop('JFK', 'ORY', 'JUN 05', '6h 25m', '\$851', '9:26 am - 3:43 pm'),
    AirAsiaFlightStop('MRG', 'FTB', 'JUN 20', '6h 25m', '\$532', '9:26 am - 3:43 pm'),
    AirAsiaFlightStop('ERT', 'TVS', 'JUN 20', '6h 25m', '\$718', '9:26 am - 3:43 pm'),
    AirAsiaFlightStop('KKR', 'RTY', 'JUN 20', '6h 25m', '\$663', '9:26 am - 3:43 pm'),
  ];

  static final _stopKeys = List<GlobalKey<AirAsiaFlightStopCardState>>.unmodifiable(
      _flightStops.map<GlobalKey<AirAsiaFlightStopCardState>>((_) => GlobalKey<AirAsiaFlightStopCardState>()));

  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  double get _planeTopPadding => _minPlanePaddingTop + (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;
  double get _maxPlaneTopPadding => widget.height - _minPlanePaddingTop - _initialPlanePaddingBottom - _planeSize;
  double get _planeSize => _planeSizeAnimation.value;

  void _initSize() {
    _planeSizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 500), () {
            widget.onPlaneFlightStart?.call();
            _planeTravelController.forward();
          });
          Future.delayed(const Duration(milliseconds: 700), () {
            _dotsAnimationController.forward();
          });
        }
      });
    _planeSizeAnimation = Tween<double>(begin: 60.0, end: 36.0).animate(CurvedAnimation(
      parent: _planeSizeAnimationController,
      curve: Curves.easeOut,
    ));
  }

  void _initPlaneTravel() {
    _planeTravelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _initDots() {
    _dotsAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animateFlightStopCards().then((dynamic _) => _animateFab());
        }
      });
    //what part of whole animation takes one dot travel
    const slideDurationInterval = 0.4;
    //what are delays between dot animations
    const slideDelayInterval = 0.2;
    //at the bottom of the screen
    final startingMarginTop = widget.height;
    //minimal margin from the top (where first dot will be placed)
    final minMarginTop = _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * AirAsiaFlightStopCard.height);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;
      final finalMarginTop = minMarginTop + i * (0.8 * AirAsiaFlightStopCard.height);

      final animation = Tween<double>(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        CurvedAnimation(
          parent: _dotsAnimationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotsPositionAnimation.add(animation);
    }
  }

  void _initFab() {
    _fabAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fabAnimation = CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut);
  }

  Future _animateFlightStopCards() async {
    return Future.forEach(_stopKeys, (GlobalKey<AirAsiaFlightStopCardState> stopKey) {
      return Future<dynamic>.delayed(const Duration(milliseconds: 250), () => stopKey.currentState.runAnimation());
    });
  }

  void _animateFab() => _fabAnimationController.forward();

  @override
  void initState() {
    super.initState();
    _initSize();
    _initPlaneTravel();
    _initDots();
    _initFab();
    _planeSizeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildPlane(),
          ..._flightStops.map(_buildStopCard),
          ..._flightStops.map(_mapFlightStopToDot),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildStopCard(AirAsiaFlightStop stop) {
    final index = _flightStops.indexOf(stop);
    final topMargin = _dotsPositionAnimation[index].value - 0.5 * (AirAsiaFlightStopCard.height - AirAsiaDot.size);
    final isLeft = index.isOdd;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
              child: AirAsiaFlightStopCard(
                key: _stopKeys[index],
                flightStop: stop,
                isLeft: isLeft,
              ),
            ),
            !isLeft ? Container() : Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _mapFlightStopToDot(AirAsiaFlightStop stop) {
    final index = _flightStops.indexOf(stop);
    final isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    final color = isStartOrEnd ? Colors.red : Colors.green;
    return AirAsiaDot(
      animation: _dotsPositionAnimation[index],
      color: color,
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      builder: (context, child) => Positioned(
        top: _planeTopPadding,
        child: child,
      ),
      child: Column(
        children: <Widget>[
          AirAsiaPlaneIcon(animation: _planeSizeAnimation),
          Container(
            width: 2.0,
            height: _flightStops.length * AirAsiaFlightStopCard.height * 0.8,
            color: const Color.fromARGB(255, 200, 200, 200),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (_) => AirAsiaTicketsPage()));
          },
          child: Icon(Icons.check, size: 36.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }
}
