/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'text_notifier.dart';

typedef TextChanged = bool Function(String text);

class ValidateItemConsumer extends StatelessWidget {
  final String title;
  final TextChanged onValueChanged;

  const ValidateItemConsumer(
      {Key key, @required this.title, @required this.onValueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TextNotifier>(
      builder: (_, notifier, __) {
        final valid = onValueChanged(notifier.value);
        return ValidateItem(title: title, valid: valid);
      },
    );
  }
}

class ValidateItem extends StatefulWidget {
  final String title;
  final bool valid;

  const ValidateItem({Key key, @required this.title, @required this.valid})
      : super(key: key);

  @override
  _ValidateItemState createState() => _ValidateItemState();
}

class _ValidateItemState extends State<ValidateItem>
    with TickerProviderStateMixin<ValidateItem> {
  AnimationController _controller;
  AnimationController _strikeController;
  Animation<double> _spaceWidth;
  Animation<double> _strikePercent;

  @override
  void didUpdateWidget(ValidateItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valid != oldWidget.valid) {
      _playAnimation(widget.valid);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _strikeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _spaceWidth = Tween<double>(begin: 8, end: 12)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _strikePercent = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _strikeController, curve: Curves.easeOut));
  }

  _playAnimation(bool strikeIn) async {
    strikeIn
        ? await _strikeController.forward()
        : await _strikeController.reverse();
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 32),
        AnimatedBuilder(
            animation: _spaceWidth,
            builder: (_, __) => SizedBox(width: _spaceWidth.value)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedBuilder(
            animation: _strikePercent,
            builder: (_, __) => CustomPaint(
              foregroundPainter: StrikeThroughPainter(_strikePercent.value),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.valid ? Colors.black54 : Colors.black87,
                  fontSize: 18,
                  fontFamily: 'UbuntuMono',
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 32),
      ],
    );
  }
}

class StrikeThroughPainter extends CustomPainter {
  final double percent;

  const StrikeThroughPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, (size.height / 2) - 2, size.width * percent, 4),
        Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
