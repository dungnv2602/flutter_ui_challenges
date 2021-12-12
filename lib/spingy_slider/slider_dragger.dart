/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'springy_slider_controller.dart';

class SliderDragger extends StatefulWidget {
  final SpringySliderController sliderController;
  final Widget child;
  final double paddingTop;
  final double paddingBottom;

  const SliderDragger({
    Key key,
    @required this.sliderController,
    @required this.child,
    this.paddingTop = 0,
    this.paddingBottom = 0,
  })  : assert(sliderController != null),
        assert(child != null),
        super(key: key);

  @override
  _SliderDraggerState createState() => _SliderDraggerState();
}

class _SliderDraggerState extends State<SliderDragger> {
  double startDragY;
  double startDragPercent;

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    startDragPercent = widget.sliderController.sliderValue;

    /// calculate draggingHorizontalPercent
    final RenderBox renderBox = context.findRenderObject();
    final sliderWidth = context.size.width;
    final sliderLeftPosition = renderBox.localToGlobal(Offset.zero).dx;
    final dragHorizontalPercent =
        (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.onDragStart(dragHorizontalPercent);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    /// calculate draggingVerticalPercent
    final dragDistance = startDragY - details.globalPosition.dy;
    final sliderHeight =
        context.size.height - widget.paddingTop - widget.paddingBottom;
    final dragPercent = dragDistance / sliderHeight;

    widget.sliderController.draggingVerticalPercent =
        startDragPercent + dragPercent;

    /// calculate draggingHorizontalPercent
    final RenderBox renderBox = context.findRenderObject();
    final sliderWidth = context.size.width;
    final sliderLeftPosition = renderBox.localToGlobal(Offset.zero).dx;
    final dragHorizontalPercent =
        (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.draggingHorizontalPercent = dragHorizontalPercent;
  }

  void _onPanEnd(DragEndDetails details) {
    startDragY = null;
    startDragPercent = null;

    widget.sliderController.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}
