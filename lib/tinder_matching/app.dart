import 'package:flutter/material.dart';

import 'card_stack.dart';
import 'match_engine.dart';
import 'profiles.dart';
import 'tinder_engine.dart';

/// design: Tinder
/// Implementation originated by Matt Carroll/Fluttery
/// With my own workarounds and improvements

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TINDER',
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appBar = AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: const FlutterLogo(
      size: 32,
      textColor: Colors.red,
    ),
    leading: IconButton(
      icon: Icon(
        Icons.person,
        color: Colors.grey,
        size: 32,
      ),
      onPressed: () {},
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.chat_bubble,
          size: 32,
          color: Colors.grey,
        ),
        onPressed: () {},
      ),
    ],
  );

  final _matchEngine = MatchEngine(
    matches: demoProfiles.map((Profile profile) {
      return DateMatch(profile: profile);
    }).toList(),
  );

  final TinderEngine _tinderEngine = TinderEngine();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: CardStack(
        matchEngine: _matchEngine,
        tinderEngine: _tinderEngine,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RoundedIconButton.small(
                iconData: Icons.refresh,
                color: Colors.orange,
                onPressed: () {},
              ),
              RoundedIconButton.large(
                iconData: Icons.clear,
                color: Colors.red,
                onPressed: _tinderEngine.nope,
              ),
              RoundedIconButton.small(
                iconData: Icons.star,
                color: Colors.blue,
                onPressed: _tinderEngine.superLike,
              ),
              RoundedIconButton.large(
                iconData: Icons.favorite,
                color: Colors.green,
                onPressed: _tinderEngine.like,
              ),
              RoundedIconButton.small(
                iconData: Icons.lock,
                color: Colors.purple,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    Key key,
    @required this.iconData,
    @required this.color,
    this.onPressed,
    @required this.size,
  }) : super(key: key);

  const RoundedIconButton.large({
    Key key,
    @required this.iconData,
    @required this.color,
    this.onPressed,
  })  : size = 60.0,
        super(key: key);

  const RoundedIconButton.small({
    Key key,
    @required this.iconData,
    @required this.color,
    this.onPressed,
  })  : size = 50.0,
        super(key: key);

  final Color color;
  final IconData iconData;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
          ),
        ],
      ),
      child: RawMaterialButton(
        shape: const CircleBorder(),
        elevation: 0,
        child: Icon(
          iconData,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
