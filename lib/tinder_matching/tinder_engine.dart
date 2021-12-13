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
