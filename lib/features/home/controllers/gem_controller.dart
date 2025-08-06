import 'package:flutter/material.dart';

class GemController with ChangeNotifier {
  int _gems = 505;

  int get gems => _gems;

  // ✅ Thêm: Tăng số lượng gem
  void addGems(int amount) {
    _gems += amount;
    notifyListeners();
  }

  // ✅ Giữ lại: Tăng 1 gem đơn lẻ nếu cần
  void addGem(int amount) {
    _gems += amount;
    notifyListeners();
  }

  void useGem(int amount) {
    if (_gems >= amount) {
      _gems -= amount;
      notifyListeners();
    }
  }

  bool canAfford(int amount) => _gems >= amount;
}
