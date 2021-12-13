import 'dart:math';

import 'package:flutter/material.dart';

class CardScroller extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final double padding;
  final double hiddenCardVerticalInset;
  final double cardAspectRatio;
  final bool isOpaque;
  final BorderRadius borderRadius;
  final bool reverse;
  final IndexedWidgetBuilder itemBuilder;

  const CardScroller({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.pageController,
    this.reverse = false,
    this.isOpaque = true,
    this.padding = 20,
    this.hiddenCardVerticalInset = 20,
    this.cardAspectRatio = 27 / 41,
    this.borderRadius = BorderRadius.zero,
  })  : assert(pageController != null),
        assert(itemCount != null),
        assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _CardScrollWidget(
          padding: padding,
          cardAspectRatio: cardAspectRatio,
          hiddenCardVerticalInset: hiddenCardVerticalInset,
          borderRadius: borderRadius,
          textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
          isOpaque: isOpaque,
          controller: pageController,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
        Positioned.fill(
          child: PageView.builder(
            reverse: reverse,
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            itemCount: itemCount,
            itemBuilder: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _CardScrollWidget extends StatelessWidget {
  final PageController controller;
  final int itemCount;
  final double padding;
  final double hiddenCardVerticalInset;
  final double widgetAspectRatio;
  final double cardAspectRatio;
  final bool isOpaque;
  final BorderRadius borderRadius;
  final TextDirection textDirection;
  final IndexedWidgetBuilder itemBuilder;

  const _CardScrollWidget({
    Key key,
    @required this.controller,
    @required this.itemCount,
    @required this.itemBuilder,
    this.padding = 20,
    this.hiddenCardVerticalInset = 20,
    this.cardAspectRatio = 27 / 41,
    this.borderRadius = BorderRadius.zero,
    this.textDirection = TextDirection.ltr,
    this.isOpaque = true,
  })  : assert(controller != null),
        assert(itemCount != null),
        assert(itemBuilder != null),
        widgetAspectRatio = 1.2 * cardAspectRatio,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
//          final currentPage  = calculateCurrentPage(controller);
          final currentPage = controller.hasClients
              ? controller.page
              : controller.initialPage; // check if controller is attached or not yet
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final safeWidth = width - 2 * padding;
              final safeHeight = height - 2 * padding;

              final primaryCardHeight = safeHeight;
              final primaryCardWidth = primaryCardHeight * cardAspectRatio;

              final primaryCardLeft = safeWidth - primaryCardWidth;

              final hiddenCardHorizontalInset = primaryCardLeft / 2;

              final cards = <Widget>[];

              for (int index = 0; index < itemCount; index++) {
                //should be positive if page is to the right, negative if to the left
                final deltaFromCurrentPage = (index - currentPage).toDouble();

                //this early return prevents us from adding invisible cards to the hierarchy
                if (deltaFromCurrentPage > 1 || deltaFromCurrentPage < -4) continue;

                final isOnRight = deltaFromCurrentPage > 0;

                final opacity = isOpaque ? _calculateOpacity(deltaFromCurrentPage) : 1.0;

                final start = padding +
                    max(primaryCardLeft - hiddenCardHorizontalInset * -deltaFromCurrentPage * (isOnRight ? 15 : 1),
                        0.0);

                // left card should become smaller
                final top = padding + hiddenCardVerticalInset * max(-deltaFromCurrentPage, 0.0);
                // right card shouldn't become bigger
                final bottom = padding + hiddenCardVerticalInset * max(-deltaFromCurrentPage, 0.0);

                final card = Positioned.directional(
                  key: Key('Positioned.directional-$index'),
                  textDirection: textDirection,
                  top: top,
                  bottom: bottom,
                  start: start,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Container(
                      decoration: deltaFromCurrentPage < 0 ? BoxDecoration(color: Colors.white) : const BoxDecoration(),
                      child: Opacity(
                        opacity: opacity,
                        child: AspectRatio(
                          aspectRatio: cardAspectRatio,
                          child: itemBuilder(context, index),
                        ),
                      ),
                    ),
                  ),
                );

                cards.add(card);
              }
              return Stack(
                children: cards,
              );
            },
          );
        },
      ),
    );
  }
}

num _calculateOpacity(num deltaFromCurrentPage) {
  double opacity;
  if (deltaFromCurrentPage < 0) {
    //page is off the left
    opacity = (1 + 0.33 * deltaFromCurrentPage).clamp(0.0, 1.0);
  } else if (deltaFromCurrentPage < 1) {
    //page is the current page, possibly moving to the right
    opacity = (1 - 2 * (deltaFromCurrentPage - deltaFromCurrentPage.floor())).clamp(0.0, 1.0);
  } else {
    //page is way off the right side, so should be invisible.
    opacity = 0.0;
  }
  return opacity;
}
