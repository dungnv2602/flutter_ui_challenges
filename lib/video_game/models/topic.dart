/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

class Topic {
  final String question;
  final String recentAnswer;
  final String answerCount;

  Topic({this.question, this.recentAnswer, this.answerCount});
}

final fortniteTopics = [
  Topic(
    question: "Should we drop early?",
    recentAnswer: "I hear this question often, so I figured I'd start a thread. When I drop early it usually",
    answerCount: "1241",
  ),
  Topic(
    question: "Quitting FN because of this",
    recentAnswer: "Literally done with game until they balance the map better so that the blue corner",
    answerCount: "238",
  ),
];

final pubgTopics = fortniteTopics;
