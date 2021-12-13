import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'card_detail.dart';
import 'models.dart';

class CardsSection extends StatefulWidget {
  final List<BankCard> cards;

  const CardsSection({Key key, @required this.cards}) : super(key: key);

  @override
  _CardsSectionState createState() => _CardsSectionState();
}

class _CardsSectionState extends State<CardsSection> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: controller,
          itemCount: widget.cards.length,
          itemBuilder: (_, index) {
            return Container();
          },
        ),
        Cards(controller: controller, cards: widget.cards),
      ],
    );
  }
}

class Cards extends StatelessWidget {
  final PageController controller;
  final List<BankCard> cards;

  const Cards({
    Key key,
    @required this.controller,
    @required this.cards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final currentPage = calculateCurrentPage(controller);
        return LayoutBuilder(
          builder: (_, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final widgets = <Widget>[];
            for (int index = 0; index < cards.length; index++) {
              final delta = currentPage - index;
              widgets.add(Center(
                child: Transform.rotate(
                  angle: -delta * pi / 14,
                  origin: Offset(0, 3 * min(maxWidth, maxHeight)),
                  child: VerticalCard(card: cards[index]),
                ),
              ));
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: widgets,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VerticalCard extends StatelessWidget {
  final BankCard card;

  const VerticalCard({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //ensure this doesn't intercept touch events
        //only the gesture detector below should catch touches
        //and it is set to allow touches to pass through
        //so that the PageView below these can also receive those same touch events
        IgnorePointer(
          child: Center(
            child: AspectRatio(
              aspectRatio: CARD_ASPECT_RATIO,
              child: Hero(
                tag: 'image-${card.code}',
                child: Transform.rotate(
                  angle: pi / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      card.imgPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                flightShuttleBuilder: (_, animation, direction, fromContext, toContext) {
                  final Hero toHero = toContext.widget;
                  return CustomRotationTransition(
                    turns: animation,
                    child: toHero,
                    reverse: direction == HeroFlightDirection.push,
                  );
                },
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: Hero(
              tag: 'title-${card.code}',
              child: Text(
                card.code,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black87,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ),
              flightShuttleBuilder: (_, __, ___, fromContext, toContext) {
                final toHero = toContext.widget;
                return Material(
                  color: Colors.transparent,
                  child: toHero,
                );
              },
            ),
          ),
        ),
        Center(
          //this should be the only widget in this stack listening for touch events
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            //this flag allows the gesture detector to both receive touch events AND pass them on to widgets behind it which mean this widget can receive tap events, but the pageview below can handle swipes at the same time
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetail(card: card))),
            child: AspectRatio(
              //this is a vertical container of the same size as the above rotated image used for hit detection
              // GestureDetectors don't play well with rotations for some reason
              aspectRatio: 1 / CARD_ASPECT_RATIO,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRotationTransition extends AnimatedWidget {
  final Widget child;
  final bool reverse;

  const CustomRotationTransition({
    Key key,
    @required Animation<double> turns,
    this.child,
    this.reverse,
  }) : super(key: key, listenable: turns);

  Animation<double> get turns => listenable;

  @override
  Widget build(BuildContext context) {
    final turnsValue = turns.value;
    final halfPi = pi / 2;

    final transform = reverse ? Matrix4.rotationZ((1 - turnsValue) * halfPi) : Matrix4.rotationZ(-turnsValue * halfPi);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}
