import 'package:flutter/material.dart';

final pageList = [
  PageModel(
      imageUrl: 'assets/images/onboarding/illustration.png',
      title: 'MUSIC',
      body: 'EXPERIENCE WICKED PLAYLISTS',
      titleGradient: gradients[0]),
  PageModel(
      imageUrl: 'assets/images/onboarding/illustration2.png',
      title: 'SPA',
      body: 'FEEL THE MAGIC OF WELLNESS',
      titleGradient: gradients[1]),
  PageModel(
      imageUrl: 'assets/images/onboarding/illustration3.png',
      title: 'TRAVEL',
      body: 'LET\'S HIKE UP',
      titleGradient: gradients[2]),
];

List<List<Color>> gradients = const [
  [Color(0xFF9708CC), Color(0xFF43CBFF)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  final String imageUrl;
  final String title;
  final String body;
  List<Color> titleGradient = [];

  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}
