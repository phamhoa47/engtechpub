import 'package:flutter/material.dart';

class TopicCategory {
  final String name;
  final IconData icon;

  TopicCategory({required this.name, required this.icon});
}

class HomeMenuController extends ChangeNotifier {
  // 🟡 Danh sách chủ đề
  final List<TopicCategory> topicCategories = [
    TopicCategory(name: 'AI', icon: Icons.smart_toy),
    TopicCategory(name: 'Cybersecurity', icon: Icons.shield),
    TopicCategory(name: 'DevOps', icon: Icons.cloud),
    TopicCategory(name: 'Frontend', icon: Icons.phone_android),
    TopicCategory(name: 'Backend', icon: Icons.dns),
    TopicCategory(name: 'Data', icon: Icons.bar_chart),
  ];

  // ✅ Thêm progress cho bài học chính
  int correctCount = 0;
  int totalQuestions = 10;

  double get progress => correctCount / totalQuestions;

  void increaseCorrect() {
    if (correctCount < totalQuestions) {
      correctCount++;
      notifyListeners();
    }
  }

  void resetProgress() {
    correctCount = 0;
    notifyListeners();
  }
}
