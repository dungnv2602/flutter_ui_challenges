import 'package:flutter/material.dart';

const titleStyle = TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2);

const subtitleStyle = TextStyle(color: Colors.black54, fontWeight: FontWeight.bold);

class AvatarWidget extends StatelessWidget {
  final XdModel model;

  const AvatarWidget({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 8),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          model.avatarImgPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

const models = [
  XdModel(
    backgroundImgPath: 'assets/images/carousel/bahama.jpg',
    avatarImgPath: 'assets/images/base/ellie.png',
    title: 'Bahama',
    collabs: '12',
    desc:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  XdModel(
    backgroundImgPath: 'assets/images/carousel/capetown.jpg',
    avatarImgPath: 'assets/images/base/eric.png',
    title: 'Capetown',
    collabs: '32',
    desc:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  XdModel(
    backgroundImgPath: 'assets/images/carousel/dubai.jpg',
    avatarImgPath: 'assets/images/base/jenny.png',
    title: 'Dubai',
    collabs: '2400',
    desc:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  XdModel(
    backgroundImgPath: 'assets/images/carousel/newyork.jpg',
    avatarImgPath: 'assets/images/base/kevin.png',
    title: 'Newyork',
    collabs: '8',
    desc:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  XdModel(
    backgroundImgPath: 'assets/images/carousel/paris.jpg',
    avatarImgPath: 'assets/images/base/louis.png',
    title: 'Paris',
    collabs: '128',
    desc:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
];

class XdModel {
  final String backgroundImgPath;
  final String avatarImgPath;
  final String title;
  final String collabs;
  final String desc;

  const XdModel({
    @required this.backgroundImgPath,
    @required this.avatarImgPath,
    @required this.title,
    @required this.collabs,
    @required this.desc,
  });
}
