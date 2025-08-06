import 'package:flutter/material.dart';

class UserStatusController with ChangeNotifier {
  int diamonds = 505;
  int hearts = 3;

  void earnDiamonds(int amount) {
    diamonds += amount;
    notifyListeners();
  }

  bool spendDiamonds(int amount) {
    if (diamonds >= amount) {
      diamonds -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void loseHeart() {
    if (hearts > 0) {
      hearts -= 1;
      notifyListeners();
    }
  }

  bool restoreHeartByDiamonds(int cost) {
    if (spendDiamonds(cost)) {
      hearts = 1; // reset 1 tym để tiếp tục
      notifyListeners();
      return true;
    }
    return false;
  }

  void resetHearts() {
    hearts = 3;
    notifyListeners();
  }
}
