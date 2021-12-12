import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // status bar
        Container(
          width: double.infinity,
          height: 20.0,
        ),
        // cards
        Expanded(
          child: CardFlipper(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(index: index);
            },
            onScroll: (percent) {
              setState(() {
                scrollPercent = percent;
              });
            },
          ),
        ),
        // bottom bar
        BottomBar(
          itemCount: 5,
          scrollPercent: scrollPercent,
        ),
      ],
    );
  }
}

class CardFlipper extends StatefulWidget {
  const CardFlipper({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    this.onScroll,
  }) : super(key: key);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(double scrollPercent) onScroll;

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with SingleTickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;

  double scrollPercent = 0.0;
  Offset startDrag;
  double startScrollPercent;
  double snapStartPercent;
  double snapEndPercent;

  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();
    finishScrollController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(snapStartPercent, snapEndPercent, finishScrollController.value);
          widget.onScroll?.call(scrollPercent);
        });
      });
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    finishScrollController.stop();

    startDrag = details.globalPosition;
    startScrollPercent = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    // drag left => < 0; drag right => > 0
    final dragDistance = currentDrag.dx - startDrag.dx;

    // viewport = 1 => full screen width
    // multiply viewportFraction here
    final dragPercent = dragDistance / size.width;

    final fullDragPercent = dragPercent / widget.itemCount;

    // minus the last card, if not the last card will scroll to the left end
    // final maxClamp = 1 - 1 / widget.itemCount;
    final maxClamp = 1 - 1 / widget.itemCount;

    setState(() {
      scrollPercent = 0.0 + (startScrollPercent - fullDragPercent).clamp(0.0, maxClamp);
    });

    widget.onScroll?.call(scrollPercent);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    snapStartPercent = scrollPercent;

    final normalizedIndex = (scrollPercent * widget.itemCount).round();

    snapEndPercent = normalizedIndex / widget.itemCount;

    setState(() {
      startDrag = null;
      startScrollPercent = null;
    });

    finishScrollController.forward(from: 0.0);
  }

  List<Widget> _buildCards() {
    return List.generate(widget.itemCount, _buildCard);
  }

  Widget _buildCard(int index) {
    final amountOfScroll = 1 / widget.itemCount;

    final cardScrollPercent = scrollPercent / amountOfScroll;

    // how far to the left have we scrolled
    final parallax = scrollPercent - index / widget.itemCount;

    return FractionalTranslation(
      translation: Offset(index - cardScrollPercent, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        // child: widget.itemBuilder(context, index),
        child: Card(
          index: index,
          parallax: parallax,
        ),
      ),
    );
    // return FractionalTranslation(
    //   translation: Offset(0.1 * index, 0),
    //   child: Card(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key key,
    @required this.index,
    this.parallax = 0.0,
  }) : super(key: key);

  final int index;
  final double parallax;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // background
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FractionalTranslation(
            translation: Offset(parallax * 2.0, 0.0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Image.asset(
                'assets/images/pic${index + 1}.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Text(
                '10th Street'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '2-3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
                    letterSpacing: -5.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 30),
                  child: Text(
                    'FT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '65.1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'Mostly Cloud',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '11.2mph ENE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key key,
    @required this.itemCount,
    @required this.scrollPercent,
  }) : super(key: key);

  final int itemCount;
  final double scrollPercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 5.0,
              child: ScrollIndicator(
                itemCount: itemCount,
                scrollPercent: scrollPercent,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({Key key, @required this.itemCount, @required this.scrollPercent}) : super(key: key);

  final int itemCount;
  final double scrollPercent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
        itemCount: itemCount,
        scrollPercent: scrollPercent,
      ),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  ScrollIndicatorPainter({@required this.itemCount, @required this.scrollPercent})
      : trackPaint = Paint()
          ..color = const Color(0xFF444444)
          ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  final int itemCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: const Radius.circular(3.0),
        bottomLeft: const Radius.circular(3.0),
        topRight: const Radius.circular(3.0),
        bottomRight: const Radius.circular(3.0),
      ),
      trackPaint,
    );

    final thumbWidth = size.width / itemCount;
    final thumbLeft = scrollPercent * size.width;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          thumbLeft,
          0.0,
          thumbWidth,
          size.height,
        ),
        topLeft: const Radius.circular(3.0),
        bottomLeft: const Radius.circular(3.0),
        topRight: const Radius.circular(3.0),
        bottomRight: const Radius.circular(3.0),
      ),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(ScrollIndicatorPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ScrollIndicatorPainter oldDelegate) => true;
}
