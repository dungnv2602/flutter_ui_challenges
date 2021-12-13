import 'dart:ui';

import 'package:flutter/material.dart';

import 'material_page_reveal.dart';

class PageIndicators extends StatelessWidget {
  final PageIndicatorsViewModel indicatorViewModel;

  const PageIndicators({
    Key key,
    @required this.indicatorViewModel,
  })  : assert(indicatorViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbles = <PageBubble>[];
    for (int index = 0; index < indicatorViewModel.pages.length; ++index) {
      final isHollow = index > indicatorViewModel.currentPageIndex ||
          (index == indicatorViewModel.currentPageIndex &&
              indicatorViewModel.slideDirection == SlideDirection.leftToRight);

      double activePercent;
      if (index == indicatorViewModel.currentPageIndex) {
        activePercent = 1 - indicatorViewModel.slidePercent;
      } else if (index == indicatorViewModel.currentPageIndex - 1 &&
          indicatorViewModel.slideDirection == SlideDirection.leftToRight) {
        activePercent = indicatorViewModel.slidePercent;
      } else if (index == indicatorViewModel.currentPageIndex + 1 &&
          indicatorViewModel.slideDirection == SlideDirection.rightToLeft) {
        activePercent = indicatorViewModel.slidePercent;
      } else {
        activePercent = 0;
      }

      bubbles.add(
        PageBubble(
          bubbleViewModel: PageIndicatorViewModel(
            indicatorIcon: indicatorViewModel.pages[index].indicatorIcon,
            isHollow: isHollow,
            activePercent: activePercent,
          ),
        ),
      );
    }

    final baseTranslation = (indicatorViewModel.pages.length - 1) / 2 * MAX_INDICATOR_SIZE;

    var translationX = baseTranslation - indicatorViewModel.currentPageIndex * MAX_INDICATOR_SIZE;

    if (indicatorViewModel.slideDirection == SlideDirection.leftToRight) {
      translationX += indicatorViewModel.slidePercent * MAX_INDICATOR_SIZE;
    } else if (indicatorViewModel.slideDirection == SlideDirection.rightToLeft) {
      translationX -= indicatorViewModel.slidePercent * MAX_INDICATOR_SIZE;
    }

    return Column(
      children: <Widget>[
        const Spacer(),
        Transform(
          transform: Matrix4.translationValues(translationX, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

class PageBubble extends StatelessWidget {
  final PageIndicatorViewModel bubbleViewModel;

  const PageBubble({
    Key key,
    @required this.bubbleViewModel,
  })  : assert(bubbleViewModel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: MAX_INDICATOR_SIZE - 10,
      height: MAX_INDICATOR_SIZE,
      child: Center(
        child: Container(
          // calculate the value between 20 & 45 based on activePercent
          width: lerpDouble(
            MIN_INDICATOR_SIZE,
            MAX_INDICATOR_SIZE,
            bubbleViewModel.activePercent,
          ),
          // calculate the value between 20 & 45 based on activePercent
          height: lerpDouble(
            MIN_INDICATOR_SIZE,
            MAX_INDICATOR_SIZE,
            bubbleViewModel.activePercent,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // if isHollow => display border
            // else display fill
            color: bubbleViewModel.isHollow
                ? INDICATOR_COLOR.withAlpha((0x88 * bubbleViewModel.activePercent).round())
                : INDICATOR_COLOR,
            border: Border.all(
              color: bubbleViewModel.isHollow
                  ? INDICATOR_COLOR.withAlpha((0x88 * (1 - bubbleViewModel.activePercent)).round())
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: Opacity(
            opacity: bubbleViewModel.activePercent,
            child: Center(
              child: bubbleViewModel.indicatorIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class PageIndicatorsViewModel {
  final List<PageViewModel> pages;
  final int currentPageIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  const PageIndicatorsViewModel({
    @required this.pages,
    @required this.currentPageIndex,
    @required this.slideDirection,
    @required this.slidePercent,
  })  : assert(pages != null),
        assert(currentPageIndex != null),
        assert(slideDirection != null),
        assert(slidePercent != null);
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PageIndicatorViewModel {
  final bool isHollow;
  final double activePercent;
  final Widget indicatorIcon;

  const PageIndicatorViewModel({
    @required this.isHollow,
    @required this.activePercent,
    this.indicatorIcon,
  })  : assert(isHollow != null),
        assert(activePercent != null);
}
