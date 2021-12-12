/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'artist_details_animator.dart';

/// Implementation originated by: https://iirokrankka.com/2018/03/06/from-design-to-flutter-artist-details-page/
/// With my own workarounds and improvements
/// Source: https://www.uplabs.com/posts/artist-and-user-profiles

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArtistDetailsAnimator();
  }
}
