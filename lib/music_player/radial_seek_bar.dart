import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'music_player.dart';

class RadialSeekBar extends StatefulWidget {
  final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested;

  const RadialSeekBar({
    Key key,
    this.progress = 0,
    this.seekPercent = 0,
    @required this.onSeekRequested,
  })  : assert(onSeekRequested != null),
        super(key: key);

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _progress;

  PolarCoord _startDragCoord;

  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _progress = widget.progress;
    }
  }

  void _onRadialDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _progress;
  }

  void _onRadialDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(() {
      _currentDragPercent = (_startDragPercent + dragPercent) % 1;
    });
  }

  void _onRadialDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    setState(() {
      _progress = _currentDragPercent;
      _currentDragPercent = null;
      _startDragPercent = null;
      _startDragCoord = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: 150,
            width: 150,
            child: _RadialProgressBar(
              innerPadding: const EdgeInsets.all(10),
              progressColor: accentColor,
              thumbColor: lightAccentColor,
              trackColor: const Color(0xFFDDDDDD),
              progressPercent: _progress,
              thumbPosition: thumbPosition,
              child: ClipOval(
                clipper: _CircleClipper(),
                child: Image.asset(
                  'assets/images/carousel/bahama.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialProgressBar extends StatelessWidget {
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final double progressPercent;
  final double thumbPosition;

  final Widget child;

  final double trackWidth;
  final double progressWidth;
  final double thumbSize;
  final Color trackColor;
  final Color progressColor;
  final Color thumbColor;

  const _RadialProgressBar({
    Key key,
    this.trackWidth = 3,
    this.progressWidth = 5,
    this.thumbSize = 10,
    this.trackColor = Colors.grey,
    this.progressColor = Colors.black,
    this.thumbColor = Colors.black,
    this.progressPercent = 0,
    this.thumbPosition = 0,
    this.outerPadding = const EdgeInsets.all(0),
    this.innerPadding = const EdgeInsets.all(0),
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: CustomPaint(
        /// paint the foreground
        foregroundPainter: _ProgressBarPainter(
          progressPercent: progressPercent,
          thumbPosition: thumbPosition,
          progressWidth: progressWidth,
          trackWidth: trackWidth,
          thumbSize: thumbSize,
          progressColor: progressColor,
          trackColor: trackColor,
          thumbColor: thumbColor,
        ),
        child: Padding(
          padding: _insetsForPainter() + innerPadding,
          child: child,
        ),
      ),
    );
  }

  EdgeInsets _insetsForPainter() {
    double outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    outerThickness = outerThickness / 2;
    return EdgeInsets.all(outerThickness);
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progressPercent;
  final double thumbPosition;
  final double trackWidth;
  final double progressWidth;
  final double thumbSize;
  final Color trackColor;
  final Color progressColor;
  final Color thumbColor;

  final Paint trackPaint;
  final Paint progressPaint;
  final Paint thumbPaint;

  _ProgressBarPainter({
    @required this.trackWidth,
    @required this.progressWidth,
    @required this.thumbSize,
    @required this.trackColor,
    @required this.progressColor,
    @required this.thumbColor,
    @required this.progressPercent,
    @required this.thumbPosition,
  })  : assert(trackWidth != null),
        assert(progressWidth != null),
        assert(thumbSize != null),
        assert(trackColor != null),
        assert(progressColor != null),
        assert(thumbColor != null),
        assert(progressPercent != null),
        assert(thumbPosition != null),
        trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final center = Offset(width / 2, height / 2);

    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));

    final Size constrainedSize = Size(width - outerThickness, height - outerThickness);

    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    /// paint track
    canvas.drawCircle(center, radius, trackPaint);

    /// paint progress
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progressPercent;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // TODO(joe): study trigonometry to understand this
    /// paint thumb
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) =>
      progressPercent != oldDelegate.progressPercent ||
      thumbPosition != oldDelegate.thumbPosition ||
      trackWidth != oldDelegate.trackWidth ||
      progressWidth != oldDelegate.progressWidth ||
      thumbSize != oldDelegate.thumbSize ||
      trackColor != oldDelegate.trackColor ||
      progressColor != oldDelegate.progressColor;

  @override
  bool shouldRebuildSemantics(_ProgressBarPainter oldDelegate) => false;
}

class _CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final height = size.height;
    final width = size.width;
    final center = Offset(width / 2, height / 2);
    final radius = min(width, height) / 2;
    return Rect.fromCircle(center: center, radius: radius);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => this != oldClipper;
}
