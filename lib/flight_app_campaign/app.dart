/// Implementation originated by: https://github.com/fdoyle/flutter-trip-demo
/// With my own workarounds and improvements
/// design: https://dribbble.com/shots/2938101-Flight-App-Campaign-Screen

// TODO fix card padding on small devices + animation + performance issue

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'flight_card.dart';
import 'shared/constants.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flight App Campaign',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Ubuntu',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _viewportFraction = 0.8;
  AnimationController _controller;
  PageController _primaryController;
  PageController _secondaryController;
  PageController _tertiaryController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _primaryController = PageController(viewportFraction: _viewportFraction);
    _secondaryController = PageController(viewportFraction: _viewportFraction);
    _tertiaryController = PageController(viewportFraction: _viewportFraction);

    _primaryController.addListener(() {
      final secondPixels = _getPixelsFromPage(
          page: _primaryController.page,
          viewportDimension: _secondaryController.position.viewportDimension,
          viewportFraction: _viewportFraction);

      final tertiaryPixels = _getPixelsFromPage(
          page: _primaryController.page,
          viewportDimension: _tertiaryController.position.viewportDimension,
          viewportFraction: _viewportFraction);

      _secondaryController.jumpTo(secondPixels);
      _tertiaryController.jumpTo(tertiaryPixels);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  double _getPixelsFromPage({double page, double viewportDimension, double viewportFraction}) {
    return page * viewportDimension * viewportFraction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const _Background(),
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                _TopTitle(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        pageSnapping: false,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _secondaryController,
                        itemCount: flights.length,
                        itemBuilder: (_, index) {
                          return _DestinationBackground(
                            controller: _secondaryController,
                            index: index,
                          );
                        },
                      ),
                      PageView.builder(
                        pageSnapping: true,
                        physics: const BouncingScrollPhysics(),
                        controller: _primaryController,
                        itemCount: flights.length,
                        itemBuilder: (_, index) {
                          return FlightCard(
                            controller: _primaryController,
                            index: index,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _IndexCounter(controller: _tertiaryController),
                const SizedBox(height: 64),
                _BottomRow(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexCounter extends StatelessWidget {
  final PageController controller;

  const _IndexCounter({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 16,
          width: 8,
          child: PageView.builder(
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: controller,
            itemCount: flights.length,
            itemBuilder: (_, index) {
              return _IndexCount(
                controller: controller,
                index: index,
              );
            },
          ),
        ),
        Text(' / ${flights.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _IndexCount extends StatelessWidget {
  final int index;
  final PageController controller;

  const _IndexCount({Key key, @required this.index, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final tween = calculatePowTweenWithIndex(index: index, controller: controller, velocity: 10);
        return Opacity(
          opacity: tween,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }
}

class _DestinationBackground extends StatelessWidget {
  final int index;
  final PageController controller;

  const _DestinationBackground({Key key, @required this.index, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flight = flights[index];

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final tween = calculatePowTweenWithIndex(index: index, controller: controller, velocity: 20);
        final curve = Curves.easeInOut.transform(tween);

        return Opacity(
          opacity: 0.2 * curve,
          child: FractionalTranslation(
            translation: Offset(-0.3 * curve, 0.0),
            child: Text(
              flight.destination,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: background,
            ),
          ),
        );
      },
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;

  const _Background({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            white,
            Colors.transparent,
          ],
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
          stops: const [0.0, 1.0],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            purple,
            redPurple,
          ],
        ),
      ),
      child: child,
    );
  }
}

class _TopTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'CAMPAIGNS',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white.withOpacity(0.8),
        letterSpacing: 1,
      ),
    );
  }
}

class _BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.cloud_queue, size: 28, color: Colors.white.withOpacity(0.8)),
          Icon(Icons.access_time, size: 28, color: Colors.white.withOpacity(0.5)),
          Icon(Icons.mic_none, size: 28, color: Colors.white.withOpacity(0.5)),
          Icon(Icons.fingerprint, size: 28, color: Colors.white.withOpacity(0.5)),
        ],
      ),
    );
  }
}
