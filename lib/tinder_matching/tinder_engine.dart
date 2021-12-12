/*
 * Copyright (c) 2020. Joe Ng - dungnv2602. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/foundation.dart';

class TinderEngine extends ChangeNotifier {
  TinderFunctions _func = TinderFunctions.none;

  TinderFunctions get func => _func;

  void nope() {
    _func = TinderFunctions.nope;
    notifyListeners();
  }

  void like() {
    _func = TinderFunctions.like;
    notifyListeners();
  }

  void superLike() {
    _func = TinderFunctions.superLike;
    notifyListeners();
  }
}

enum TinderFunctions {
  nope,
  like,
  superLike,
  none,
}
