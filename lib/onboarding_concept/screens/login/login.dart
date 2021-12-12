import 'package:flutter/material.dart';

import '../../constants.dart';
import 'widgets/index.dart';

class Login extends StatefulWidget {
  const Login({
    @required this.screenHeight,
    this.background,
  }) : assert(screenHeight != null);

  final double screenHeight;
  final Image background;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _formElementAnimation;
  Animation<double> _headerTextAnimation;
  Animation<double> _greyContainerClipperAnimation;
  Animation<double> _blueContainerClipperAnimation;
  Animation<double> _whiteContainerClipperAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
    _animationController.addStatusListener(_onDismissed);

    _headerTextAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
    );
    _formElementAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.7,
        1.0,
        curve: Curves.easeInOut,
      ),
    );

    final clipperOffsetTween = Tween<double>(
      begin: widget.screenHeight,
      end: 0.0,
    );

    _whiteContainerClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _blueContainerClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.35,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _greyContainerClipperAnimation = clipperOffsetTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.5,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void reassemble() {
    super.reassemble();
    _animationController.forward(from: 0);
  }

  void _onDismissed(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _animationController.reverse();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kWhite,
        body: Stack(
          children: <Widget>[
            widget.background ?? const SizedBox.shrink(),
            AnimatedBuilder(
              animation: _greyContainerClipperAnimation,
              builder: (_, child) => ClipPath(
                clipper: GreyContainerClipper(yOffset: _greyContainerClipperAnimation.value),
                child: child,
              ),
              child: Container(color: kGrey),
            ),
            AnimatedBuilder(
              animation: _blueContainerClipperAnimation,
              builder: (_, child) => ClipPath(
                clipper: BlueContainerClipper(yOffset: _blueContainerClipperAnimation.value),
                child: child,
              ),
              child: Container(color: kBlue),
            ),
            AnimatedBuilder(
              animation: _whiteContainerClipperAnimation,
              builder: (_, child) => ClipPath(
                clipper: WhiteContainerClipper(yOffset: _whiteContainerClipperAnimation.value),
                child: child,
              ),
              child: Container(color: kWhite),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kPaddingL),
                child: Column(
                  children: <Widget>[
                    Header(animation: _headerTextAnimation),
                    const Spacer(),
                    LoginForm(animation: _formElementAnimation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
