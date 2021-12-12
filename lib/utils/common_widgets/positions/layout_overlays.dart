/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * This class is a modified version from the original authored by Matt Carroll/Fluttery
 * Credit goes to Matt Carroll/Fluttery
 */

import 'package:flutter/widgets.dart';

/// Utility [AnchoredOverlay] over [Center] widget
class CenterAnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor)
      overlayBuilder;

  const CenterAnchoredOverlay({
    key,
    this.showOverlay = false,
    @required this.overlayBuilder,
  })  : assert(overlayBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: showOverlay,
      overlayBuilder: overlayBuilder,
      child: const Center(),
    );
  }
}

/// Displays an overlay Widget anchored directly above the center of this
/// [AnchoredOverlay].
///
/// The overlay Widget is created by invoking the provided [overlayBuilder].
///
/// The [anchorPosition] position is provided to the [overlayBuilder], but the builder
/// does not have to respect it. In other words, the [overlayBuilder] can
/// interpret the meaning of "anchor" however it wants - the overlay will not
/// be forced to be centered about the [anchorPosition].
///
/// The overlay built by this [AnchoredOverlay] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.
class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor)
      overlayBuilder;
  final Widget child;

  const AnchoredOverlay({
    key,
    this.showOverlay = false,
    @required this.overlayBuilder,
    @required this.child,
  })  : assert(overlayBuilder != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // This LayoutBuilder gives us the opportunity to measure the above
      // Container to calculate the "anchor" point at its center.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              // To calculate the "anchor" point we grab the render box of
              // our parent Container and then we find the center of that box.
              final RenderBox box = context.findRenderObject();
              final topLeft = box.size.topLeft(box.localToGlobal(Offset.zero));
              final bottomRight =
                  box.size.bottomRight(box.localToGlobal(Offset.zero));
              final Rect anchorBounds = Rect.fromLTRB(
                topLeft.dx,
                topLeft.dy,
                bottomRight.dx,
                bottomRight.dy,
              );
              final anchorCenter = box.size.center(topLeft);

              return overlayBuilder(overlayContext, anchorBounds, anchorCenter);
            },
            child: child,
          );
        },
      ),
    );
  }
}

/// Displays an overlay Widget as constructed by the given [overlayBuilder].
///
/// The overlay built by the [overlayBuilder] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.
///
/// Implementation note: the reason we rebuild the overlay every time our
/// state changes is because there doesn't seem to be any better way to
/// invalidate the overlay itself than to invalidate this Widget. Remember,
/// overlay Widgets exist in [OverlayEntry]s which are inaccessible to
/// outside Widgets. But if a better approach is found then feel free to use it.
class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  const OverlayBuilder({
    key,
    this.showOverlay = false,
    @required this.overlayBuilder,
    @required this.child,
  })  : assert(overlayBuilder != null),
        assert(child != null),
        super(key: key);

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    if (overlayEntry == null) {
      // Create the overlay.
      overlayEntry = OverlayEntry(
        builder: widget.overlayBuilder,
      );
      addToOverlay(overlayEntry);
    } else {
      // Rebuild overlay.
      buildOverlay();
    }
  }

  void hideOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Future<void> addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  Future<void> buildOverlay() async {
    overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => buildOverlay());
    return widget.child;
  }
}
