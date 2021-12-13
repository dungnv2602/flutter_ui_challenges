import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models.dart';
import 'util.dart';

/// design: https://dribbble.com/shots/2383984-Billabong-Surf-App-Teaser
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements

double _calculateOffset(double offset) {
  return (1.0 - offset.abs()).clamp(0.0, 1.0);
}

double _calculateGaussOffset(double offset) {
  return math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
}

Matrix4 _buildCardProjection(double scrollPercent) {
//     Projection matrix is a simplified perspective matrix
//     http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
//     in the form of
//     [[1.0, 0.0, 0.0, 0.0],
//      [0.0, 1.0, 0.0, 0.0],
//      [0.0, 0.0, 1.0, 0.0],
//      [0.0, 0.0, -perspective, 1.0]]

//     View matrix is a simplified camera view matrix.
//     Basically re-scales to keep object at original size at angle = 0 at
//     any radius in the form of
//     [[1.0, 0.0, 0.0, 0.0],
//      [0.0, 1.0, 0.0, 0.0],
//      [0.0, 0.0, 1.0, -radius],
//      [0.0, 0.0, 0.0, 1.0]]

  final perspective = Matrix4.identity()..setEntry(3, 2, -0.001); // perspective

  final angle = (90.0 * scrollPercent * math.pi) / 180.0;
  final rotating = Matrix4.identity()
    ..setEntry(0, 0, math.cos(angle))
    ..setEntry(0, 2, math.sin(angle))
    ..setEntry(2, 0, -math.sin(angle))
    ..setEntry(2, 2, math.cos(angle));

  return perspective * rotating;
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Carousel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'DroidSans',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 20,
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              pageSnapping: true,
              physics: ClampingScrollPhysics(),
              itemCount: models.length,
              itemBuilder: (_, index) {
                return WeatherCard(
                  model: models[index],
                  index: index,
                  controller: controller,
                );
              },
            ),
          ),
          SizedBox(height: 16),
          BottomBar(
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherModel model;
  final PageController controller;
  final int index;

  const WeatherCard({Key key, @required this.model, @required this.controller, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double offset = 0.0;
        if (controller.position.haveDimensions) offset = controller.page - index;
        final gaussTranslateOffset = Offset(-32 * _calculateGaussOffset(offset) * offset.sign, 0);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Transform(
            alignment: Alignment.center,
            transform: _buildCardProjection(offset),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FractionalTranslation(
                    translation: Offset(0.5 - _calculateOffset(offset) * 0.5, 0.0),
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      child: Image.asset(
                        model.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text(model.location.toUpperCase(), style: TextStyles.subtitle),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(model.degrees, style: TextStyles.title),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 32),
                          child: Text('FT', style: TextStyles.subtitle),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(model.humidity, style: TextStyles.subtitle),
                        Text('°', style: TextStyles.subtitle),
                      ],
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1.5, color: Colors.white),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(model.condition, style: TextStyles.display1),
                            SizedBox(width: 10),
                            model.icon,
                            SizedBox(width: 10),
                            Text(model.windPower, style: TextStyles.display1),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final PageController controller;

  const ScrollIndicator({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          painter: ScrollIndicatorPainter(controller.page ?? 0),
          child: Container(
            width: double.infinity,
            height: 5,
          ),
        );
      },
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final double offset;

  final Paint trackPaint = Paint()
    ..color = const Color(0xFF444444)
    ..style = PaintingStyle.fill;
  final Paint thumbPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  ScrollIndicatorPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    // draw track
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        trackPaint);

    //draw thumb
    final thumbWidth = size.width / models.length;
    final thumbLeft = thumbWidth * offset;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            thumbLeft,
            0,
            thumbWidth,
            size.height,
          ),
          topLeft: Radius.circular(3),
          topRight: Radius.circular(3),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}

class BottomBar extends StatelessWidget {
  final PageController controller;

  const BottomBar({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 32),
        Icon(Icons.settings, color: Colors.white),
        SizedBox(width: 64),
        Expanded(
          child: ScrollIndicator(
            controller: controller,
          ),
        ),
        SizedBox(width: 64),
        Icon(Icons.add, color: Colors.white),
        SizedBox(width: 32),
      ],
    );
  }
}
