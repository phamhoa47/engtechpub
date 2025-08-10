import 'package:flutter/material.dart';

class HeartController extends ChangeNotifier {
  int hearts = 3;
  final int maxHearts = 3;

  bool get isOutOfHearts => hearts <= 0;

  void loseHeart() {
    if (hearts > 0) {
      hearts--;
      notifyListeners();
    }
  }

  void addHeart() {
    if (hearts < maxHearts) {
      hearts++;
      notifyListeners();
    }
  }

  void addHearts(int amount) {
    hearts = (hearts + amount).clamp(0, maxHearts);
    notifyListeners();
  }

  void restoreHeart() {
    if (hearts < maxHearts) {
      hearts++;
      notifyListeners();
    }
  }
}
