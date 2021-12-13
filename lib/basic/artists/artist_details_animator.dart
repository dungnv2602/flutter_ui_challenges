import 'package:flutter/material.dart';

import 'artist_details.dart';
import 'models.dart';

class ArtistDetailsAnimator extends StatefulWidget {
  final Artist andy = Artist(
    firstName: 'Andy',
    lastName: 'Fraser',
    avatar: 'images/avatar.png',
    backdropPhoto: 'images/backdrop.png',
    location: 'London, England',
    biography: 'Andrew McLan "Andy" Fraser was an English songwriter and bass '
        'guitarist whose career lasted over forty years, and includes two spells '
        'as a member of the rock band Free, which he helped found in 1968, aged 15.'
        'Andrew McLan "Andy" Fraser was an English songwriter and bass '
        'guitarist whose career lasted over forty years, and includes two spells '
        'as a member of the rock band Free, which he helped found in 1968, aged 15.',
    videos: <Video>[
      Video(
        title: 'Free - Mr. Big - Live at Granada Studios 1970',
        thumbnail: 'images/video1_thumb.png',
        url: 'https://www.youtube.com/watch?v=_FhCilozomo',
      ),
      Video(
        title: 'Free - Ride on a Pony - Live at Granada Studios 1970',
        thumbnail: 'images/video2_thumb.png',
        url: 'https://www.youtube.com/watch?v=EDHNZuAnBoU',
      ),
      Video(
        title: 'Free - Songs of Yesterday - Live at Granada Studios 1970',
        thumbnail: 'images/video3_thumb.png',
        url: 'https://www.youtube.com/watch?v=eI1FT0a_bos',
      ),
      Video(
        title: 'Free - I\'ll Be Creepin\' - Live at Granada Studios 1970',
        thumbnail: 'images/video4_thumb.png',
        url: 'https://www.youtube.com/watch?v=3qK8O3UoqN8',
      ),
    ],
  );

  @override
  _ArtistDetailsAnimatorState createState() => _ArtistDetailsAnimatorState();
}

class _ArtistDetailsAnimatorState extends State<ArtistDetailsAnimator> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ArtistDetailsPage(
      artist: widget.andy,
      animationController: _controller,
    );
  }
}
