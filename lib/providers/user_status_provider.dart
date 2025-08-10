import 'package:flutter/material.dart';
import '../models/user_status.dart';

class UserStatusProvider extends ChangeNotifier {
  UserStatus _status = UserStatus(diamonds: 505, hearts: 3);

  UserStatus get status => _status;

  void loseHeart() {
    _status.loseHeart();
    notifyListeners();
  }

  void gainHeart() {
    _status.gainHeart();
    notifyListeners();
  }

  bool useDiamonds(int amount) {
    final result = _status.useDiamonds(amount);
    if (result) notifyListeners();
    return result;
  }

  void earnDiamonds(int amount) {
    _status.earnDiamonds(amount);
    notifyListeners();
  }

  void reset() {
    _status = UserStatus(diamonds: 0, hearts: 3);
    notifyListeners();
  }
}
