/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/foundation.dart';

import 'profiles.dart';

class MatchEngine extends ChangeNotifier {
  MatchEngine({
    List<DateMatch> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  int _currentMatchIndex;
  final List<DateMatch> _matches;
  int _nextMatchIndex;

  DateMatch get currentMatch => _matches[_currentMatchIndex];

  DateMatch get nextMatch => _matches[_nextMatchIndex];

  int get currentMatchIndex => _currentMatchIndex;

  int get nextMatchIndex => _nextMatchIndex;

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided) {
      currentMatch.reset();

      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex = _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;

      notifyListeners();
    }
  }
}

class DateMatch extends ChangeNotifier {
  DateMatch({
    this.profile,
  });

  final Profile profile;

  Decision _decision = Decision.undecided;

  void like() {
    if (_decision == Decision.undecided) {
      _decision = Decision.like;
      notifyListeners();
    }
  }

  void nope() {
    if (_decision == Decision.undecided) {
      _decision = Decision.nope;
      notifyListeners();
    }
  }

  void superLike() {
    if (_decision == Decision.undecided) {
      _decision = Decision.superLike;
      notifyListeners();
    }
  }

  void reset() {
    if (_decision != Decision.undecided) {
      _decision = Decision.undecided;
      notifyListeners();
    }
  }

  Decision get decision => _decision;
}

enum Decision {
  undecided,
  nope,
  like,
  superLike,
}
