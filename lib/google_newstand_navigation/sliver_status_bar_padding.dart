import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverStatusBarPadding extends SingleChildRenderObjectWidget {
  const SliverStatusBarPadding({
    Key key,
    @required this.maxHeight,
    this.scrollFactor = 5,
  })  : assert(maxHeight != null && maxHeight >= 0),
        assert(scrollFactor != null && scrollFactor >= 1),
        super(key: key);

  final double maxHeight;
  final double scrollFactor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverStatusBarPadding(
      maxHeight: maxHeight,
      scrollFactor: scrollFactor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSliverStatusBarPadding renderObject) {
    renderObject
      ..maxHeight = maxHeight
      ..scrollFactor = scrollFactor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('maxHeight', maxHeight));
    properties.add(DoubleProperty('scrollFactor', scrollFactor));
  }
}

/// Initially occupies the same space as the status bar and gets smaller as
/// the primary scrollable scrolls upwards.
class _RenderSliverStatusBarPadding extends RenderSliver {
  _RenderSliverStatusBarPadding({
    @required double maxHeight,
    @required double scrollFactor,
  })  : assert(maxHeight != null && maxHeight >= 0),
        assert(scrollFactor != null && scrollFactor >= 1),
        _maxHeight = maxHeight,
        _scrollFactor = scrollFactor;

  /// The height of status bar
  double get maxHeight => _maxHeight;
  double _maxHeight;
  set maxHeight(double value) {
    assert(_maxHeight != null && _maxHeight >= 0);
    if (_maxHeight == value) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  /// The rate at which the renderer's height shrinks when the scroll offset changes
  double get scrollFactor => _scrollFactor;
  double _scrollFactor;
  set scrollFactor(double value) {
    assert(scrollFactor != null && _scrollFactor >= 1);
    if (_scrollFactor == value) return;
    _scrollFactor = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final height = 0.0 + (maxHeight - constraints.scrollOffset / scrollFactor).clamp(0, maxHeight);
    final paintExtent = math.min(height, constraints.remainingPaintExtent);
    debugPrint('_RenderSliverStatusBarPadding: height: $height');
    debugPrint('_RenderSliverStatusBarPadding: paintExtent: $paintExtent');
    geometry = SliverGeometry(
      paintExtent: paintExtent,
      scrollExtent: maxHeight,
      maxPaintExtent: maxHeight,
    );
  }
}
