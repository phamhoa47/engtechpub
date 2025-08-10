import 'package:flutter/material.dart';

class LessonProgressController extends ChangeNotifier {
  // Lưu tiến độ theo từng phần học. Ví dụ: 'phan_1': 5
  final Map<String, int> _lessonProgress = {};

  /// Lấy tiến độ hiện tại của 1 phần học (ví dụ: 'phan_1')
  int getProgress(String partId) => _lessonProgress[partId] ?? 0;

  /// Tăng tiến độ lên 1 (sau khi trả lời đúng)
  void increaseProgress(String partId) {
    _lessonProgress[partId] = (_lessonProgress[partId] ?? 0) + 1;
    notifyListeners();
  }

  /// Đặt lại tiến độ về 0 (nếu cần reset bài học)
  void resetProgress(String partId) {
    _lessonProgress[partId] = 0;
    notifyListeners();
  }

  /// Đặt lại toàn bộ tiến độ (dùng khi reset toàn bộ app)
  void resetAll() {
    _lessonProgress.clear();
    notifyListeners();
  }
}
