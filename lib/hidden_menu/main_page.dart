import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tmdb/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_dart/tmdb_dart.dart';

import 'menu_notifier.dart';
import 'widgets/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  MenuNotifier notifier;
  StreamSubscription signInSubscription;

  @override
  void initState() {
    super.initState();
    final tmdbService = locator<TmdbService>();
    // init notifier
    notifier = MenuNotifier(
      vsync: this,
      isSignedIn: tmdbService.isSignedIn,
    );
    // listen to signin change
    signInSubscription = tmdbService.onSignedInChange.listen((value) {
      notifier.setSignedIn(isSignedIn: value);
    });
  }

  @override
  void dispose() {
    signInSubscription?.cancel();
    notifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuNotifier>(
      create: (context) => notifier,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: const <Widget>[
            // background
            MenuBackground(),
            // Menu
            MenuView(),
            // Pages
            SlideScaleView(),
          ],
        ),
      ),
    );
  }
}
