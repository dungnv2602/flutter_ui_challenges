import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'material_page_reveal.dart';

class PageDragger extends StatefulWidget {
  final StreamController<SlideUpdate> slideUpdateStream;
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  const PageDragger({
    Key key,
    @required this.slideUpdateStream,
    @required this.canDragLeftToRight,
    @required this.canDragRightToLeft,
  })  : assert(slideUpdateStream != null),
        assert(canDragLeftToRight != null),
        assert(canDragRightToLeft != null),
        super(key: key);
  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  Offset dragStart;

  SlideUpdateType slideUpdateType;
  SlideDirection slideDirection;
  double slidePercent;

  void onHorizontalDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0;
      }

      slideUpdateType = SlideUpdateType.dragging;

      // add SlideUpdate event to stream
      emitSlideUpdateEvent(slideUpdateType, slideDirection, slidePercent);
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    dragStart = null;
    slideUpdateType = SlideUpdateType.doneDragging;
    slideDirection = SlideDirection.none;
    slidePercent = 0;

    // add SlideUpdate event to stream
    emitSlideUpdateEvent(slideUpdateType, slideDirection, slidePercent);
  }

  void emitSlideUpdateEvent(SlideUpdateType slideUpdateType, SlideDirection slideDirection, double slidePercent) {
    widget.slideUpdateStream.add(
      SlideUpdate(
        slidePercent: slidePercent,
        direction: slideDirection,
        type: slideUpdateType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
    );
  }
}

class PageDraggerAnimationController {
  AnimationController controller;

  PageDraggerAnimationController({
    @required SlideDirection slideDirection,
    @required TransitionGoal transitionGoal,
    @required double slidePercent,
    @required StreamController<SlideUpdate> slideUpdateStream,
    @required TickerProvider vsync,
  })  : assert(slideDirection != null),
        assert(transitionGoal != null),
        assert(slidePercent != null),
        assert(slideUpdateStream != null),
        assert(vsync != null) {
    final startSlidePercent = slidePercent;
    double endSlidePercent;
    Duration duration;
    if (transitionGoal == TransitionGoal.open) {
      final slidePercentRemaining = 1 - slidePercent;
      endSlidePercent = 1;
      duration = Duration(milliseconds: (slidePercentRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0;
      duration = Duration(milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    controller = AnimationController(vsync: vsync, duration: duration)
      ..addListener(() {
        final slidePercent = lerpDouble(startSlidePercent, endSlidePercent, controller.value);

        slideUpdateStream.add(
          SlideUpdate(
            type: SlideUpdateType.animating,
            direction: slideDirection,
            slidePercent: slidePercent,
          ),
        );
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(
            SlideUpdate(
              type: SlideUpdateType.doneAnimating,
              direction: SlideDirection.none,
              slidePercent: 0,
            ),
          );
        }
      });
  }

  void run() {
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

class SlideUpdate {
  final SlideDirection direction;
  final double slidePercent;
  final SlideUpdateType type;
  SlideUpdate({
    @required this.direction,
    @required this.slidePercent,
    @required this.type,
  })  : assert(direction != null),
        assert(slidePercent != null),
        assert(type != null);
}

enum SlideUpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}
