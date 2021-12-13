import 'package:flutter/material.dart';

class BottomUpRoute extends PageRouteBuilder {
  final Widget exitWidget;
  final Widget enterWidget;

  BottomUpRoute({@required this.exitWidget, @required this.enterWidget})
      : super(
            pageBuilder: (_, __, ___) => enterWidget,
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              return Stack(
                children: <Widget>[
                  SlideTransition(
                    position: Tween(
                      begin: Offset.zero,
                      end: const Offset(0.0, -1.0),
                    ).animate(animation),
                    child: exitWidget,
                  ),
                  SlideTransition(
                    position: Tween(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: enterWidget,
                  ),
                ],
              );
            });
}

class RightToLeftRoute extends PageRouteBuilder {
  final Widget exitWidget;
  final Widget enterWidget;

  RightToLeftRoute({this.exitWidget, this.enterWidget})
      : super(
          pageBuilder: (_, __, ___) => enterWidget,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, ___) => Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween(
                  begin: Offset.zero,
                  end: const Offset(-1, 0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                )),
                child: exitWidget,
              ),
              SlideTransition(
                position: Tween(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                )),
                child: enterWidget,
              ),
            ],
          ),
        );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget widget;

  ScaleRoute(this.widget)
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                widget,
            transitionDuration: const Duration(milliseconds: 1000),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(
                      0.00,
                      0.50,
                      curve: Curves.linear,
                    ),
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.5,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0.50,
                        1.00,
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  child: child,
                ),
              );
            });
}
