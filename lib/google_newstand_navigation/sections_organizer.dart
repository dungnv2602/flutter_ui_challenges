import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'section_app_bar_delegate.dart';
import 'sections.dart';
import 'sliver_status_bar_padding.dart';
import 'widgets.dart';


const _kAppBackgroundColor = Color(0xFF353662);
const _kScrollDuration = Duration(milliseconds: 400);
const _kScrollCurve = Curves.fastOutSlowIn;

/// This app's contents start out at _kHeadingMaxHeight and they function like
/// an appbar. Initially the appbar occupies most of the screen and its section
/// headings are laid out in a column. By the time its height has been
/// reduced to _kAppBarMidHeight, its layout is horizontal, only one section
/// heading is visible, and the section's list of details is visible below the
/// heading. The appbar's height can be reduced to no more than _kAppBarMinHeight.
/// The AppBar's max height depends on the screen, see _AnimationDemoHomeState._buildBody()
const _kAppBarMinHeight = 90.0;
const _kAppBarMidHeight = 256.0;

const _paddedSectionIndicatorWidth = kSectionIndicatorWidth + 8.0;

const _cardId = 'card';
const _titleId = 'title';
const _indicatorId = 'indicator';

class SectionsOrganizer extends StatefulWidget {
  const SectionsOrganizer({Key key}) : super(key: key);

  @override
  _SectionsOrganizerState createState() => _SectionsOrganizerState();
}

class _SectionsOrganizerState extends State<SectionsOrganizer> {
  final _sectionScrollController = ScrollController();
  final _sectionHeadingPageController = PageController();
  final _sectionDetailPageController = PageController();

  ScrollPhysics _sectionHeadingScrollPhysics = const NeverScrollableScrollPhysics();
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);

  bool _hasInitialized = false;

  double _statusBarHeight = 0.0;
  double _appBarMaxHeight = 0.0;
  // The scroll offset that reveals the appBarMidHeight appbar.
  double _appBarMidScrollOffset = 0.0;

  final List<Widget> _sectionHeadings = <Widget>[];
  final List<Widget> _sectionDetails = <Widget>[];

  void _initializeMediaQueryData() {
    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;
    _statusBarHeight = mediaQueryData.padding.top;
    _appBarMaxHeight = screenHeight - _statusBarHeight;
    _appBarMidScrollOffset = screenHeight - _kAppBarMidHeight;
  }

  void _initSectionHeadings() {
    final List<Widget> sectionCards = <Widget>[];
    for (int index = 0; index < allSections.length; index++) {
      sectionCards.add(LayoutId(
        id: '$_cardId-$index',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (TapUpDetails details) {
            final double xOffset = details.globalPosition.dx;
            setState(() => _maybeScroll(index, xOffset));
          },
          child: SectionCard(section: allSections[index]),
        ),
      ));
    }

    for (int index = 0; index < allSections.length; index++) {
      _sectionHeadings.add(Container(
        color: _kAppBackgroundColor,
        child: ClipRect(
          child: _AllSectionsView(
            sectionIndex: index,
            sections: allSections,
            selectedIndex: selectedIndex,
            minHeight: _kAppBarMinHeight,
            midHeight: _kAppBarMidHeight,
            maxHeight: _appBarMaxHeight,
            sectionCards: sectionCards,
          ),
        ),
      ));
    }
  }

  void _initSectionDetails() {
    _sectionDetails.addAll(
      allSections.map<Widget>(
        (Section section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(section.details.length, (index) {
                return SectionDetailItemView(
                  detailItem: section.details[index],
                  imageOnly: index == 1,
                );
              }),
            ).toList(),
          );
        },
      ),
    );
  }

  void _animateSectionToOffset(double offset) {
    _sectionScrollController.animateTo(offset, duration: _kScrollDuration, curve: _kScrollCurve);
  }

  void _animateSectionHeadingToPage(int page) {
    _sectionHeadingPageController.animateToPage(page, duration: _kScrollDuration, curve: _kScrollCurve);
  }

  void _handleBackButton() {
    if (_sectionScrollController.offset >= _appBarMidScrollOffset) {
      _animateSectionToOffset(0);
    } else {
      Navigator.maybePop(context);
    }
  }

  // Only enable paging for the  when the user has scrolled to _appBarMidScrollOffset.
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      final physics = _sectionScrollController.offset >= _appBarMidScrollOffset
          ? const PageScrollPhysics()
          : const NeverScrollableScrollPhysics();
      if (physics != _sectionHeadingScrollPhysics) {
        setState(() => _sectionHeadingScrollPhysics = physics);
      }
    }
    return false;
  }

  bool _handlePageNotification(ScrollNotification notification, PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        // synchronize follower PageView with leader PageView
        // follower.position.jumpToWithoutSettling(leader.position.pixels); // ignore: deprecated_member_use
        follower.position.animateTo(
          leader.position.pixels,
          duration: const Duration(milliseconds: 1),
          curve: Curves.linear,
        );
      }
    }
    return false;
  }

  void _maybeScroll(int pageIndex, double xOffset) {
    if (_sectionScrollController.offset < _appBarMidScrollOffset) {
      // Scroll the overall list to the point where only one section card shows.
      // At the same time scroll the PageViews to the page at pageIndex.
      _animateSectionHeadingToPage(pageIndex);
      _animateSectionToOffset(_appBarMidScrollOffset);
      debugPrint('_maybeScroll: _sectionScrollController.offset < _appBarMidScrollOffset');
    } else {
      // Once one section card is showing: scroll one page forward or back.
      final double centerX = _sectionHeadingPageController.position.viewportDimension / 2.0;
      final int newPageIndex = xOffset > centerX ? pageIndex + 1 : pageIndex - 1;
      _animateSectionHeadingToPage(newPageIndex);
      debugPrint('_maybeScroll: _sectionScrollController.offset > _appBarMidScrollOffset');
      debugPrint('centerX: $centerX');
      debugPrint('newPageIndex: $newPageIndex');
    }
  }

  Widget _buildBody() {
    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: CustomScrollView(
              controller: _sectionScrollController,
              physics: MidSnappingScrollPhysics(midScrollOffset: _appBarMidScrollOffset),
              slivers: <Widget>[
                // Start out below the status bar, gradually move to the top of the screen.
                SliverStatusBarPadding(
                  maxHeight: _statusBarHeight,
                  scrollFactor: 7.0,
                ),
                // Section Headings
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SectionAppBarDelegate(
                    minHeight: _kAppBarMinHeight,
                    maxHeight: _appBarMaxHeight,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        return _handlePageNotification(
                          notification,
                          _sectionHeadingPageController,
                          _sectionDetailPageController,
                        );
                      },
                      child: PageView(
                        physics: _sectionHeadingScrollPhysics,
                        controller: _sectionHeadingPageController,
                        children: _sectionHeadings,
                      ),
                    ),
                  ),
                ),
                // Details
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 610.0,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        return _handlePageNotification(
                          notification,
                          _sectionDetailPageController,
                          _sectionHeadingPageController,
                        );
                      },
                      child: PageView(
                        controller: _sectionDetailPageController,
                        children: _sectionDetails,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: _statusBarHeight,
            left: 0.0,
            child: IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: SafeArea(
                top: false,
                bottom: false,
                child: IconButton(
                  icon: const BackButtonIcon(),
                  tooltip: 'Back',
                  onPressed: _handleBackButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kAppBackgroundColor,
      body: _buildBody(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _initializeMediaQueryData();
      _initSectionHeadings();
      _initSectionDetails();
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    _sectionScrollController.dispose();
    _sectionHeadingPageController.dispose();
    _sectionDetailPageController.dispose();
    super.dispose();
  }
}

class _AllSectionsView extends AnimatedWidget {
  _AllSectionsView({
    Key key,
    this.sectionIndex,
    @required this.sections,
    @required this.selectedIndex,
    this.minHeight,
    this.midHeight,
    this.maxHeight,
    this.sectionCards = const <Widget>[],
  })  : assert(sections != null),
        assert(sectionCards != null),
        assert(sectionCards.length == sections.length),
        assert(sectionIndex >= 0 && sectionIndex < sections.length),
        assert(selectedIndex != null),
        assert(selectedIndex.value >= 0.0 && selectedIndex.value < sections.length),
        super(key: key, listenable: selectedIndex);

  final int sectionIndex;
  final List<Section> sections;
  final ValueNotifier<double> selectedIndex;
  final double minHeight;
  final double midHeight;
  final double maxHeight;
  final List<Widget> sectionCards;

  double _selectedIndexDelta(int index) {
    return 0.0 + (index - selectedIndex.value).abs().clamp(0.0, 1.0);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final Size size = constraints.biggest;

    // The layout's progress from from a column to a row. Its value is
    // 0.0 when size.height equals the maxHeight, 1.0 when the size.height
    // equals the midHeight.
    final double tColumnToRow = 1.0 - ((size.height - midHeight) / (maxHeight - midHeight)).clamp(0.0, 1.0);

    // The layout's progress from from the midHeight row layout to
    // a minHeight row layout. Its value is 0.0 when size.height equals
    // midHeight and 1.0 when size.height equals minHeight.
    final double tCollapsedRow = 1.0 - ((size.height - minHeight) / (midHeight - minHeight)).clamp(0.0, 1.0);

    double _indicatorOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * 0.5;
    }

    double _titleOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.5;
    }

    double _titleScale(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.15;
    }

    final List<Widget> children = List<Widget>.from(sectionCards);

    for (int index = 0; index < sections.length; index++) {
      final Section section = sections[index];
      children.add(LayoutId(
        id: '$_titleId-$index',
        child: SectionTitle(
          section: section,
          scale: _titleScale(index),
          opacity: _titleOpacity(index),
        ),
      ));
    }

    for (int index = 0; index < sections.length; index++) {
      children.add(LayoutId(
        id: '$_indicatorId-$index',
        child: SectionIndicator(
          opacity: _indicatorOpacity(index),
        ),
      ));
    }

    return CustomMultiChildLayout(
      delegate: _AllSectionsLayout(
        translation: Alignment((selectedIndex.value - sectionIndex) * 2.0 - 1.0, -1.0),
        tColumnToRow: tColumnToRow,
        tCollapsedRow: tCollapsedRow,
        cardCount: sections.length,
        selectedIndex: selectedIndex.value,
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }
}

/// Arrange the section titles, indicators, and cards. The cards are only included when
/// the layout is transitioning between vertical and horizontal. Once the layout is
/// horizontal the cards are laid out by a PageView.
///
/// The layout of the section cards, titles, and indicators is defined by the
/// two 0.0-1.0 "t" parameters, both of which are based on the layout's height:
/// - tColumnToRow
///   0.0 when height is maxHeight and the layout is a column
///   1.0 when the height is midHeight and the layout is a row
/// - tCollapsedRow
///   0.0 when height is midHeight and the layout is a row
///   1.0 when height is minHeight and the layout is (still) a row
///
/// minHeight < midHeight < maxHeight
///
/// The general approach here is to compute the column layout and row size
/// and position of each element and then interpolate between them using
/// tColumnToRow. Once tColumnToRow reaches 1.0, the layout changes are
/// defined by tCollapsedRow. As tCollapsedRow increases the titles spread out
/// until only one title is visible and the indicators cluster together
/// until they're all visible.
class _AllSectionsLayout extends MultiChildLayoutDelegate {
  _AllSectionsLayout({
    this.translation,
    this.tColumnToRow,
    this.tCollapsedRow,
    this.cardCount,
    this.selectedIndex,
  });

  final Alignment translation;
  final double tColumnToRow;
  final double tCollapsedRow;
  final int cardCount;
  final double selectedIndex;

  Rect _lerpRect(Rect begin, Rect end) => Rect.lerp(begin, end, tColumnToRow);

  Offset _lerpOffset(Offset begin, Offset end) => Offset.lerp(begin, end, tColumnToRow);

  @override
  void performLayout(Size size) {
    // each card width == screen width
    final rowCardWidth = size.width;
    // column card start at padding 1/5 of screen width
    final columnCardX = size.width / 5;
    final columnCardWidth = size.width - columnCardX;
    final columnCardHeight = size.height / cardCount;

    final offset = translation.alongSize(size);

    double columnCardY = 0.0;

    double rowCardX = -selectedIndex * rowCardWidth;

    // When tCollapsed > 0 the titles spread apart
    // column title start at padding 1/10 of screen width
    final columnTitleX = size.width / 10;
    // row title width < screen width at midHeight, then spread out and finally > screen width at minHeight
    final rowTitleWidth = size.width * ((1 + tCollapsedRow) / 2.25);
    // title is placed at center of screen width
    double rowTitleX = (size.width - rowTitleWidth) / 2 - selectedIndex * rowTitleWidth;

    // When tCollapsed > 0, the indicators move closer together
    // indicator start at center of rowTitleWidth, then move closer as tCollapsedRow increases
    final rowIndicatorWidth =
        _paddedSectionIndicatorWidth + (1 - tCollapsedRow) * (rowTitleWidth - _paddedSectionIndicatorWidth);
    // indicator is placed at center of row title
    double rowIndicatorX = (size.width - rowIndicatorWidth) / 2 - selectedIndex * rowIndicatorWidth;

    // Compute the size and origin of each card, title, and indicator for the maxHeight
    // "column" layout, and the midHeight "row" layout. The actual layout is just the
    // interpolated value between the column and row layouts for t.
    for (int index = 0; index < cardCount; index++) {
      // layout the card based on index
      final columnCardRect = Rect.fromLTWH(columnCardX, columnCardY, columnCardWidth, columnCardHeight);
      final rowCardRect = Rect.fromLTWH(rowCardX, 0.0, rowCardWidth, size.height);
      final cardRect = _lerpRect(columnCardRect, rowCardRect).shift(offset);

      final cardId = '$_cardId-$index';
      if (hasChild(cardId)) {
        layoutChild(cardId, BoxConstraints.tight(cardRect.size));
        positionChild(cardId, cardRect.topLeft);
      }

      // layout the title based on index
      final titleSize = layoutChild('$_titleId-$index', BoxConstraints.loose(cardRect.size));
      final columnTitleY = columnCardRect.centerLeft.dy - titleSize.height / 2;
      final rowTitleY = rowCardRect.centerLeft.dy - titleSize.height / 2;
      final centeredRowTitleX = rowTitleX + (rowTitleWidth - titleSize.width) / 2;

      final columnTitleOrigin = Offset(columnTitleX, columnTitleY);
      final rowTitleOrigin = Offset(centeredRowTitleX, rowTitleY);
      final titleOrigin = _lerpOffset(columnTitleOrigin, rowTitleOrigin);

      final titleRect = Rect.fromPoints(titleOrigin, titleSize.bottomRight(titleOrigin));
      positionChild('$_titleId-$index', titleOrigin + offset);

      // layout the indicator for index
      final indicatorSize = layoutChild('$_indicatorId-$index', BoxConstraints.loose(cardRect.size));
      final columnIndicatorX = cardRect.centerRight.dx - indicatorSize.width - 16;
      final columnIndicatorY = cardRect.bottomRight.dy - indicatorSize.height - 16;
      final centeredRowIndicatorX = rowIndicatorX + (rowIndicatorWidth - indicatorSize.width) / 2;
      final rowIndicatorY = titleRect.bottomCenter.dy + 16;

      final columnIndicatorOrigin = Offset(columnIndicatorX, columnIndicatorY);
      final rowIndicatorOrigin = Offset(centeredRowIndicatorX, rowIndicatorY);
      final indicatorOrigin = _lerpOffset(columnIndicatorOrigin, rowIndicatorOrigin);
      positionChild('$_indicatorId-$index', indicatorOrigin + offset);

      columnCardY += columnCardHeight;
      rowCardX += rowCardWidth;
      rowTitleX += rowTitleWidth;
      rowIndicatorX += rowIndicatorWidth;
    }
  }

  @override
  bool shouldRelayout(_AllSectionsLayout oldDelegate) {
    return tColumnToRow != oldDelegate.tColumnToRow ||
        cardCount != oldDelegate.cardCount ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

/// Support snapping scrolls to the midScrollOffset
class MidSnappingScrollPhysics extends ClampingScrollPhysics {
  const MidSnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.midScrollOffset,
  })  : assert(midScrollOffset != null),
        super(parent: parent);

  final double midScrollOffset;

  @override
  MidSnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return MidSnappingScrollPhysics(midScrollOffset: midScrollOffset, parent: buildParent(ancestor));
  }

  double fromDragVelocity(double dragVelocity) {
    return math.max(dragVelocity, minFlingVelocity);
  }

  Simulation _toMidScrollOffsetSimulation(double offset, double dragVelocity) {
    return ScrollSpringSimulation(spring, offset, midScrollOffset, fromDragVelocity(dragVelocity),
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    return ScrollSpringSimulation(spring, offset, 0, fromDragVelocity(dragVelocity), tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    final simulation = super.createBallisticSimulation(position, velocity);
    final offset = position.pixels;

    if (simulation != null) {
      // The drag ended with sufficient velocity to trigger creating a simulation.
      // If the simulation is headed up towards midScrollOffset but will not reach it,
      // then snap it there. Similarly if the simulation is headed down past
      // midScrollOffset but will not reach zero, then snap it to zero.
      final simulationEnd = simulation.x(double.infinity);
      if (simulationEnd >= midScrollOffset) return simulation;
      if (velocity > 0) return _toMidScrollOffsetSimulation(offset, velocity);
      if (velocity < 0) return _toZeroScrollOffsetSimulation(offset, velocity);
    } else {
      // The user ended the drag with little or no velocity.
      // If offset >= midScrollOffset / 2 => snap to midScrollOffset
      // otherwise snap to zero.
      final double snapThreshold = midScrollOffset / 2;
      if (offset >= snapThreshold && offset < midScrollOffset) return _toMidScrollOffsetSimulation(offset, velocity);
      if (offset > 0 && offset < snapThreshold) return _toZeroScrollOffsetSimulation(offset, velocity);
    }
    return simulation;
  }
}
