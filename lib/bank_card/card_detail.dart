import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class CardDetail extends StatefulWidget {
  final BankCard card;

  const CardDetail({Key key, @required this.card}) : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.reverse();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1D3671),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 80),
              Stack(
                children: <Widget>[
                  CardImg(card: widget.card),
                  CardInfo(card: widget.card, controller: controller),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardImg extends StatelessWidget {
  final BankCard card;

  const CardImg({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CARD_ASPECT_RATIO,
      child: Hero(
        tag: 'image-${card.code}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            card.imgPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  final BankCard card;
  final AnimationController controller;

  const CardInfo({Key key, @required this.card, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CardCode(card: card),
            Expanded(child: CardSubInfo(card: card, controller: controller)),
          ],
        ),
      ),
    );
  }
}

class CardCode extends StatelessWidget {
  final BankCard card;

  const CardCode({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'title-${card.code}',
      child: Text(
        card.code,
        style: const TextStyle(
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
    );
  }
}

class CardSubInfo extends StatelessWidget {
  final BankCard card;
  final AnimationController controller;

  const CardSubInfo({Key key, @required this.card, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 8),
        AnimatedTranslation(
          animation: CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn),
          child: Text(card.number, textAlign: TextAlign.left, style: subInfoTextStyle),
        ),
        const SizedBox(height: 8),
        AnimatedTranslation(
          animation:
              CurvedAnimation(parent: controller, curve: Interval(0.3, 1.0, curve: Curves.fastLinearToSlowEaseIn)),
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/bank_card/credit-card.png',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedTranslation(
          animation:
              CurvedAnimation(parent: controller, curve: Interval(0.6, 1.0, curve: Curves.fastLinearToSlowEaseIn)),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Card Holder name'),
                  const SizedBox(height: 8),
                  Text(card.owner, textAlign: TextAlign.left, style: subInfoTextStyle),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Expiry date'),
                  const SizedBox(height: 8),
                  Text(card.expirationDate, textAlign: TextAlign.left, style: subInfoTextStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedTranslation extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const AnimatedTranslation({Key key, @required this.animation, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Opacity(
          opacity: animation.value,
          child: FractionalTranslation(
            translation: Offset(0, 1 - animation.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

const subInfoTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
  shadows: [
    Shadow(
      blurRadius: 2,
      color: Colors.black87,
      offset: Offset.zero,
    ),
  ],
);
