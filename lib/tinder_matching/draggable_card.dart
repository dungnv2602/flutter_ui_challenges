import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';

import 'tinder_engine.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({
    @required this.card,
    this.tinderEngine,
    this.onSlideUpdate,
    this.onSlideOutComplete,
    this.isDraggable = true,
  }) : assert(card != null);

  final Widget card;
  final bool isDraggable;
  final TinderEngine tinderEngine;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> with TickerProviderStateMixin {
  final _profileCardKey = GlobalKey(debugLabel: 'profile_card_key');

  Offset _cardOffset = Offset.zero;
  Offset _dragStart;
  Offset _dragPosition;
  Offset _slideBackStart;

  SlideDirection _slideOutDirection;

  AnimationController _slideBackAnimation;
  AnimationController _slideOutAnimation;
  Tween<Offset> _slideOutTween;

  @override
  void initState() {
    super.initState();
    _slideBackAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _cardOffset = Offset.lerp(
            _slideBackStart,
            Offset.zero,
            Curves.elasticOut.transform(_slideBackAnimation.value),
          );

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(_cardOffset.distance);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dragStart = null;
            _slideBackStart = null;
            _dragPosition = null;
          });
        }
      });

    _slideOutAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _cardOffset = _slideOutTween.evaluate(_slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(_cardOffset.distance);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dragStart = null;
            _dragPosition = null;
            _slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(_slideOutDirection);
            }
          });
        }
      });

    // trigger sliding when animateSlideTo change
    if (widget.tinderEngine != null) {
      widget.tinderEngine.addListener(() {
        switch (widget.tinderEngine.func) {
          case TinderFunctions.nope:
            _slideLeft();
            break;
          case TinderFunctions.like:
            _slideRight();
            break;
          case TinderFunctions.superLike:
            _slideUp();
            break;
          case TinderFunctions.none:
            break;
        }
      });
    }
  }

  Offset _chooseRandomDragStart() {
    final cardContext = _profileCardKey.currentContext;
    final cardWidth = MediaQuery.of(cardContext).size.width;
    final cardHeight = MediaQuery.of(cardContext).size.height;

    final cardTopLeft = (cardContext.findRenderObject() as RenderBox).localToGlobal(Offset.zero);

    // half width => center
    final dragStartX = cardWidth / 2 + cardTopLeft.dx;

    // 25% or 75 % height based on flipping coin
    final dragStartY = cardHeight * (math.Random().nextDouble() < 0.5 ? 0.25 : 0.75) + cardTopLeft.dy;

    return Offset(dragStartX, dragStartY);
  }

  void _slideLeft() {
    _dragStart = _chooseRandomDragStart();
    _slideOutTween = Tween(begin: Offset.zero, end: Offset(-2 * screenWidth, 0.0));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _slideRight() {
    _dragStart = _chooseRandomDragStart();
    _slideOutTween = Tween(begin: Offset.zero, end: Offset(2 * screenWidth, 0.0));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() {
    _dragStart = _chooseRandomDragStart();
    _slideOutTween = Tween(begin: Offset.zero, end: Offset(0.0, -2 * screenHeight));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.globalPosition;

    if (_slideBackAnimation.isAnimating) {
      _slideBackAnimation.stop();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.globalPosition;
      _cardOffset = _dragPosition - _dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(_cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = _cardOffset / _cardOffset.distance;
    final isInLeftRegion = (_cardOffset.dx / screenWidth) < -0.45;
    final isInRightRegion = (_cardOffset.dx / screenWidth) > 0.45;
    final isInTopRegion = (_cardOffset.dy / screenHeight) < -0.40;

    if (isInLeftRegion || isInRightRegion) {
      _slideOutTween = Tween(begin: _cardOffset, end: dragVector * 2 * screenWidth);
      _slideOutAnimation.forward(from: 0.0);

      _slideOutDirection = isInLeftRegion ? SlideDirection.left : SlideDirection.right;
    } else if (isInTopRegion) {
      _slideOutTween = Tween(begin: _cardOffset, end: dragVector * 2 * screenHeight);
      _slideOutAnimation.forward(from: 0.0);

      _slideOutDirection = SlideDirection.up;
    } else {
      _slideBackStart = _cardOffset;
      _slideBackAnimation.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      child: const Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: Transform(
            transform: Matrix4.translationValues(_cardOffset.dx, _cardOffset.dy, 0.0)..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: _profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child: widget.isDraggable
                  ? GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: widget.card,
                    )
                  : widget.card,
            ),
          ),
        );
      },
    );
  }

  double _rotation(Rect dragBounds) {
    if (_dragStart != null) {
      final rotationCornerMultiplier = _dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (math.pi / 8) * (_cardOffset.dx / dragBounds.width) * rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (_dragStart != null) {
      return dragBounds.center;
    } else {
      return Offset.zero;
    }
  }

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // the card will flip back to center when slide out complete
    if (widget.card.key != oldWidget.card.key) {
      _cardOffset = Offset.zero;
    }
  }

  @override
  void dispose() {
    _slideBackAnimation.dispose();
    _slideOutAnimation.dispose();
    super.dispose();
  }
}

enum SlideDirection {
  left,
  right,
  up,
}
