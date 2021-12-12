/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'topic.dart';

class Forum {
  final String title;
  final String imagePath;
  final String rank;
  final List<Topic> topics;
  final String threads;
  final String subs;

  Forum({this.title, this.imagePath, this.rank, this.threads, this.subs, this.topics});
}

final fortniteForum = Forum(
  title: "Fortnite",
  imagePath: "assets/images/video_game/fortnite.jpg",
  rank: "31",
  threads: "34",
  subs: "123+",
  topics: fortniteTopics,
);

final pubgForum = Forum(
  title: "PUBG",
  imagePath: "assets/images/video_game/pubg.png",
  rank: "25",
  threads: "56",
  subs: "563+",
  topics: pubgTopics,
);

final forumsList = [forums1, forums2, forums3];

final forums1 = [
  fortniteForum,
  pubgForum,
  fortniteForum,
  pubgForum,
  fortniteForum,
  pubgForum,
];
final forums2 = [
  pubgForum,
  fortniteForum,
  pubgForum,
  fortniteForum,
  pubgForum,
  fortniteForum,
];
final forums3 = [
  fortniteForum,
  fortniteForum,
  fortniteForum,
  pubgForum,
  pubgForum,
  pubgForum,
];
