import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../login/login.dart';
import 'pages/index.dart';
import 'widgets/index.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    @required this.screenHeight,
  }) : assert(screenHeight != null);

  final double screenHeight;

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  AnimationController _cardsAnimationController;
  AnimationController _pageIndicatorAnimationController;
  AnimationController _rippleAnimationController;

  Animation<Offset> _slideAnimationLightCard;
  Animation<Offset> _slideAnimationDarkCard;
  Animation<double> _pageIndicatorAnimation;
  Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setCardsSlideOutAnimation();
    _setPageIndicatorAnimation(isCounterClockwise: false);
  }

  void _initAnimations() {
    _cardsAnimationController = AnimationController(
      vsync: this,
      duration: kCardAnimationDuration,
    );
    _pageIndicatorAnimationController = AnimationController(
      vsync: this,
      duration: kButtonAnimationDuration,
    );
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.screenHeight,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.easeIn,
    ));

    _rippleAnimationController.addStatusListener(_toLogin);
  }

  void _setCardsSlideInAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: const Offset(3.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: const Offset(1.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setCardsSlideOutAnimation() {
    setState(() {
      _slideAnimationLightCard = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-3.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setPageIndicatorAnimation({bool isCounterClockwise = false}) {
    final multiplicator = isCounterClockwise ? -2 : 2;

    setState(() {
      _pageIndicatorAnimation = Tween<double>(
        begin: 0.0,
        end: multiplicator * math.pi,
      ).animate(
        CurvedAnimation(
          parent: _pageIndicatorAnimationController,
          curve: Curves.easeIn,
        ),
      );
      _pageIndicatorAnimationController.reset();
    });
  }

  Future<void> _nextPage() async {
    switch (_currentPage) {
      case 1:
        if (_pageIndicatorAnimationController.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(2);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
          _setCardsSlideOutAnimation();
          _setPageIndicatorAnimation(isCounterClockwise: true);
        }
        break;
      case 2:
        if (_pageIndicatorAnimationController.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(3);
          _setCardsSlideInAnimation();
          await _cardsAnimationController.forward();
          _setCardsSlideOutAnimation();
          _setPageIndicatorAnimation(isCounterClockwise: false);
        }
        break;
      case 3:
        if (_pageIndicatorAnimationController.status == AnimationStatus.dismissed) {
          _goToLogin();
        }
        break;
    }
  }

  void _triggerForwardRipple() {
    if (_pageIndicatorAnimationController.value > 0.5) {
      _rippleAnimationController.forward();
      _pageIndicatorAnimation.removeListener(_triggerForwardRipple);
    }
  }

  void _triggerReverseIndicator() {
    if (_rippleAnimationController.value < 0.2) {
      _pageIndicatorAnimationController.reverse();
      _pageIndicatorAnimation.removeListener(_triggerReverseIndicator);
    }
  }

  Future<void> _toLogin(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await Navigator.of(context).push<bool>(
        PageRouteBuilder<bool>(
          pageBuilder: (_, __, ___) => Login(screenHeight: widget.screenHeight),
          transitionDuration: Duration.zero,
        ),
      );
      _pageIndicatorAnimationController.duration = kButtonAnimationDuration;
      _rippleAnimationController.addListener(_triggerReverseIndicator);
      await _rippleAnimationController.reverse();
    }
  }

  Future<void> _goToLogin() async {
    _pageIndicatorAnimationController.duration = Duration(milliseconds: kButtonAnimationDuration.inMilliseconds ~/ 2);
    _pageIndicatorAnimationController.addListener(_triggerForwardRipple);
    await _pageIndicatorAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingL),
              child: Column(
                children: <Widget>[
                  Header(onSkip: _goToLogin),
                  Expanded(child: _getPage()),
                  AnimatedBuilder(
                    animation: _pageIndicatorAnimation,
                    builder: (_, child) {
                      return OnboardingPageIndicator(
                        startAngle: _pageIndicatorAnimation.value,
                        currentPage: _currentPage,
                        child: child,
                      );
                    },
                    child: NextPageButton(
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Ripple(
            animation: _rippleAnimation,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  int _currentPage = 1;

  bool get isFirstPage => _currentPage == 1;

  void _setNextPage(int nextPageNumber) => setState(() => _currentPage = nextPageNumber);

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return OnboardingPage(
          number: 1,
          lightCardChild: const CommunityLightCardContent(),
          darkCardChild: const CommunityDarkCardContent(),
          textColumn: const CommunityTextColumn(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
        );
      case 2:
        return OnboardingPage(
          number: 2,
          lightCardChild: const EducationLightCardContent(),
          darkCardChild: const EducationDarkCardContent(),
          textColumn: const EducationTextColumn(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
        );
      case 3:
        return OnboardingPage(
          number: 3,
          lightCardChild: const WorkLightCardContent(),
          darkCardChild: const WorkDarkCardContent(),
          textColumn: const WorkTextColumn(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
        );
    }
    return null; // unreachable
  }

  @override
  void dispose() {
    _cardsAnimationController.dispose();
    _pageIndicatorAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }
}
