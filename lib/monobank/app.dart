/// Implementation originated by: https://github.com/fdoyle/flutter_demo_monobank
/// With my own workarounds and improvements
// design: https://dribbble.com/shots/5519790-Monobank-PFM

import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'models.dart';

// Constant factor to convert and angle from degrees to radians.
const double degrees2Radians = pi / 180.0;

// Constant factor to convert and angle from radians to degrees.
const double radians2Degrees = 180.0 / pi;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController chartController;

  @override
  void initState() {
    super.initState();
    chartController = PageController();
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: AnimatedBuilder(
          animation: chartController,
          builder: (_, __) {
            final currentPageOffset = calculateCurrentPage(chartController);
            debugPrint('currentPageOffset: $currentPageOffset');
            final currentPage = currentPageOffset.floor(); // round down
            debugPrint('chartController.page: $currentPageOffset');
            debugPrint('chartController.page.round: ${currentPageOffset.round()}');
            debugPrint('chartController.page.floor: ${currentPageOffset.floor()}');
            debugPrint('chartController.page.ceil: ${currentPageOffset.ceil()}');

            final nextPage = currentPage + 1;
            final respectiveDistance = currentPage - currentPageOffset;
            debugPrint('respectiveDistance: $respectiveDistance');

            final currentPageEntryPercentage = bankingData.entryPercentages[currentPage];
            debugPrint('currentPageEntryPercentage: $currentPageEntryPercentage');

            final currentPageSectionStartPercentage = bankingData.sectionStartPercentages[currentPage];
            debugPrint('currentPageSectionStartPercentage: $currentPageSectionStartPercentage');

            final sectionStartOffsetPercent =
                respectiveDistance * currentPageEntryPercentage + currentPageSectionStartPercentage;
            debugPrint('sectionStartOffsetPercent: $sectionStartOffsetPercent');

            final nextPageEntryPercentage =
                nextPage >= bankingData.entryPercentages.length ? 0 : bankingData.entryPercentages[nextPage];
            debugPrint('nextPageEntryPercentage: $nextPageEntryPercentage');

            final nextPageSectionStartPercentage = nextPage >= bankingData.sectionStartPercentages.length
                ? 0
                : bankingData.sectionStartPercentages[nextPage];
            debugPrint('nextPageSectionStartPercentage: $nextPageSectionStartPercentage');

            final sectionEndOffsetPercent =
                respectiveDistance * nextPageEntryPercentage + nextPageSectionStartPercentage;
            debugPrint('sectionEndOffsetPercent: $sectionEndOffsetPercent');

            /// degrees
            final startDegrees = 360 * sectionStartOffsetPercent;
            debugPrint('startDegrees: $startDegrees');
            final endDegrees = 360 * sectionEndOffsetPercent;
            debugPrint('endDegrees: $endDegrees');

            /// colors
            final currentColor = bankingData.entries[currentPage].color;
            final nextColor = nextPage >= bankingData.entries.length ? Colors.red : bankingData.entries[nextPage].color;
            final blendedColor =
                Color.alphaBlend(nextColor.withAlpha((255 * respectiveDistance).round()), currentColor).withAlpha(80);

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _Background(blendedColor: blendedColor),
                PageView.builder(
                  controller: chartController,
                  itemCount: bankingData.entries.length,
                  itemBuilder: (_, index) => _Data(index: index),
                ),
                IgnorePointer(
                  child: CustomPaint(
                    painter:
                        PieChartPainter(currentColor: currentColor, nextColor: nextColor, blendedColor: blendedColor),
                  ),
                ),
                IgnorePointer(
                  child: CustomPaint(
                    painter: PieChartOverlayArcPainter(
                      startDegrees: startDegrees,
                      endDegrees: endDegrees,
                      currentColor: currentColor,
                      nextColor: nextColor,
                      respectiveDistance: respectiveDistance,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const INSET = 10;

class PieChartOverlayArcPainter extends CustomPainter {
  final double startDegrees;
  final double endDegrees;
  final MaterialColor currentColor;
  final MaterialColor nextColor;
  final double respectiveDistance;

  const PieChartOverlayArcPainter(
      {this.startDegrees, this.endDegrees, this.currentColor, this.nextColor, this.respectiveDistance});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);
    final radius = min(width, height) / 2;
    final innerPieChartRadius = radius / 2 + INSET;

    /// angles
    final startAngle = startDegrees * degrees2Radians;
    final endAngle = endDegrees * degrees2Radians;

    /// colors
    final startColor = Color.alphaBlend(nextColor.withAlpha((255 * respectiveDistance).round()), currentColor);
    final endColor =
        Color.alphaBlend(nextColor.shade800.withAlpha((255 * respectiveDistance).round()), currentColor.shade800);
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: TileMode.repeated,
      colors: [startColor, endColor],
    );

    /// draw
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.saveLayer(rect, Paint());
    canvas.drawArc(
      rect,
      startAngle,
      endAngle - startAngle,
      true,
      Paint()..shader = gradient.createShader(rect),
    );
    canvas.drawCircle(
      center,
      innerPieChartRadius,
      Paint()
        ..blendMode = BlendMode.clear
        ..color = Colors.black,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(PieChartOverlayArcPainter oldDelegate) =>
      startDegrees != oldDelegate.startDegrees ||
      endDegrees != oldDelegate.endDegrees ||
      currentColor != oldDelegate.currentColor ||
      nextColor != oldDelegate.nextColor ||
      respectiveDistance != oldDelegate.respectiveDistance;

  @override
  bool shouldRebuildSemantics(PieChartOverlayArcPainter oldDelegate) => false;
}

class PieChartPainter extends CustomPainter {
  final Color currentColor;
  final Color nextColor;
  final Color blendedColor;

  const PieChartPainter({this.currentColor, this.nextColor, this.blendedColor});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);
    final radius = min(width, height) / 2;
    final innerPieChartRadius = radius / 2 + INSET;

    canvas.saveLayer(Rect.fromCircle(center: center, radius: radius), Paint()); // ?: can replace drawCircle instead?

    canvas.drawColor(Colors.black26, BlendMode.srcATop);

    canvas.drawCircle(center, radius - INSET, Paint()..color = blendedColor);

    canvas.drawCircle(
        center,
        innerPieChartRadius,
        Paint()
          ..color = Colors.black
          ..blendMode = BlendMode.clear);

    bankingData.sectionStartPercentages.forEach((percentage) {
      canvas.drawLine(
          center,
          center + Offset(cos(percentage * 2 * pi) * radius, sin(percentage * 2 * pi) * radius),
          Paint()
            ..blendMode = BlendMode.clear
            ..strokeWidth = 2);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      currentColor != oldDelegate.currentColor || nextColor != oldDelegate.nextColor || blendedColor != blendedColor;

  @override
  bool shouldRebuildSemantics(PieChartPainter oldDelegate) => false;
}

class _Data extends StatelessWidget {
  final int index;

  const _Data({Key key, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final entry = bankingData.entries[index];
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              '\$${entry.amount} ',
              style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Text(
              '${entry.label}',
              style: TextStyle(color: entry.color, fontSize: 20),
            )
          ],
        ),
        ClipOval(
          clipper:
              IconPagerClipper(), //this clips the paging icon so that it only appears within the clear inner part of the pie chart
          child: Center(
            child: Icon(
              entry.icon,
              color: entry.color,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}

class IconPagerClipper extends CustomClipper<Rect> {
  //? really need this with ClipOval?
  @override
  Rect getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(width, height) / 2;
    final innerPieChartRadius = radius / 2 + INSET;
    final center = Offset(width / 2, height / 2);
    return Rect.fromCircle(center: center, radius: innerPieChartRadius);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => this != oldClipper;
}

class _Background extends StatelessWidget {
  final Color blendedColor;

  const _Background({Key key, this.blendedColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.5, // ? why 1.5?
          stops: const [0, 2], // ?: why is 2?
          colors: [
            blendedColor,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
