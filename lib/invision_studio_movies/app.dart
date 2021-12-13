/// Implementation originated by: https://github.com/fdoyle/flutter_demo_movies
/// With my own workarounds and improvements
/// Design: https://dribbble.com/shots/3982621-InVision-Studio-Movies-app-concept
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

// TODO: implement the rest of the design
const data = [
  "https://i.imgur.com/tY3sbBZ.jpg",
  "https://cdn.shopify.com/s/files/1/0969/9128/products/Art_Poster_-_Sicario_-_Tallenge_Hollywood_Collection_47b4ca39-2fb6-45a2-9e85-d9ef34016e8a.jpg?v=1505078993",
  "https://m.media-amazon.com/images/M/MV5BMTU2NjA1ODgzMF5BMl5BanBnXkFtZTgwMTM2MTI4MjE@._V1_.jpg",
  "https://cdn-images-1.medium.com/max/1600/1*H-WYYsGMF4Wu6R0iPzORGg.png",
  "https://static01.nyt.com/images/2017/09/24/arts/24movie-posters1/24movie-posters1-jumbo.jpg",
];

const MOVIE_POSTER_ASPECT_RATIO = 27 / 41;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: data.length - 1);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Movies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red,
                    ),
                    width: 10,
                    height: 10,
                  ),
                  Spacer(),
                  CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/carousel/bahama.jpg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CardScroller(
              cardAspectRatio: 0.6,
              borderRadius: BorderRadius.circular(10),
              pageController: pageController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final image = data[index];
                return PosterCard(
                  imageAssetPath: image,
                  isNetworkImage: true,
                  isHero: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PosterCard extends StatelessWidget {
  final bool isNetworkImage;
  final bool isHero;
  final String imageAssetPath;

  const PosterCard({Key key, @required this.isNetworkImage, @required this.isHero, @required this.imageAssetPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = isNetworkImage
        ? CachedNetworkImage(
            imageUrl: imageAssetPath,
            fit: BoxFit.cover,
            placeholder: (_, __) => Image.asset(
              'assets/images/carousel/bahama.jpg',
              fit: BoxFit.cover,
            ),
            errorWidget: (_, __, error) {
              debugPrint('CachedNetworkImage - ERROR: ${error.toString()}');
              return Icon(Icons.error);
            },
          )
        : Image.asset(imageAssetPath, fit: BoxFit.cover);

    return isHero
        ? Hero(
            tag: 'hero-$imageAssetPath',
            child: child,
          )
        : child;
  }
}
