import 'package:flutter/material.dart';

import '../utils/utils.dart';

/// Implementation originated by: https://github.com/devefy/Flutter-Story-App-UI
/// With my own workarounds and improvements
/// Design: https://dribbble.com/shots/3844950-Story-App-Concept

class HomePage extends StatelessWidget {
  final pageController = PageController(initialPage: images.length - 1); // from the bottom is a must

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color(0xFF1b1e44),
            Color(0xFF2d3447),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 30, 12, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomIconButton(
                        icon: Icons.sort,
                        size: 30,
                      ),
                      CustomIconButton(
                        icon: Icons.search,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                const CustomSection(
                  title: 'Trending',
                  storiesNo: '25+ Stories',
                  customChip: CustomChip(
                    color: Color(0xFFff6e6e),
                    title: 'Animated',
                  ),
                ),
                const SizedBox(height: 8),
                CardScroller(
                  pageController: pageController,
                  itemCount: images.length,
                  cardAspectRatio: CARD_ASPECT_RATIO,
                  borderRadius: BorderRadius.circular(16),
                  isOpaque: false,
                  reverse: true,
                  itemBuilder: (_, index) => CardDetails(
                    imageAssetPath: images[index],
                    title: title[index],
                  ),
                ),
                const SizedBox(height: 8),
                CustomSection(
                  title: 'Favourite',
                  storiesNo: '25+ Stories',
                  customChip: CustomChip(
                    color: Colors.blueAccent,
                    title: 'Latest',
                  ),
                ),
                const SizedBox(height: 8),
                CardScroller(
                  pageController: pageController,
                  itemCount: images.length,
                  cardAspectRatio: CARD_ASPECT_RATIO,
                  borderRadius: BorderRadius.circular(16),
                  isOpaque: false,
                  itemBuilder: (_, index) => CardDetails(
                    imageAssetPath: images[index],
                    title: title[index],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardDetails extends StatelessWidget {
  final String imageAssetPath;
  final String title;

  const CardDetails({Key key, @required this.imageAssetPath, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(imageAssetPath, fit: BoxFit.cover),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'SF-Pro-Text-Regular'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    CustomChip(color: Colors.blueAccent, title: 'Read Later'),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSection extends StatelessWidget {
  final String title;
  final CustomChip customChip;
  final String storiesNo;

  const CustomSection({Key key, @required this.title, @required this.customChip, @required this.storiesNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: titleStyle),
              CustomIconButton(
                icon: Icons.more_horiz,
                size: 24,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              customChip,
              const SizedBox(width: 15),
              Text(storiesNo, style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPress;

  const CustomIconButton({Key key, @required this.icon, @required this.size, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: size,
      onPressed: onPress,
    );
  }
}

class CustomChip extends StatelessWidget {
  final Color color;
  final String title;

  const CustomChip({Key key, @required this.color, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

const CARD_ASPECT_RATIO = 3 / 4;

const titleStyle = TextStyle(
  color: Colors.white,
  fontSize: 46.0,
  fontFamily: 'Calibre-Semibold',
  letterSpacing: 1.0,
);

List<String> images = [
  'assets/images/story_app/image_04.jpg',
  'assets/images/story_app/image_03.jpg',
  'assets/images/story_app/image_02.jpg',
  'assets/images/story_app/image_01.png',
];

List<String> title = [
  'Hounted Ground',
  'Fallen In Love',
  'The Dreaming Moon',
  'Jack the Persian and the Black Castel',
];
