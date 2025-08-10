import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gem_controller.dart'; // ✅ Đảm bảo đúng đường dẫn

class LessonUnlockController with ChangeNotifier {
  // Danh sách các phần đã mở (ví dụ: Phần 1 luôn mở sẵn)
  final Set<int> _unlockedLessons = {1};

  // Kiểm tra xem phần học đã được mở chưa
  bool isUnlocked(int part) => _unlockedLessons.contains(part);

  // Mở khóa bài học nếu đủ gem
  void tryUnlockLesson(BuildContext context, int part) {
    final gemController = context.read<GemController>();
    final cost = _getLessonCost(part);

    if (gemController.canAfford(cost)) {
      gemController.useGem(cost); //
      _unlockedLessons.add(part);
      notifyListeners();
    } else {
      // Hiển thị thông báo không đủ đá quý
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Bạn không đủ đá quý để mở bài học này."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  int costToUnlock(int part) {
  switch (part) {
    case 2:
      return 100;
    case 3:
      return 200;
    default:
      return 0;
  }
}


  // Lấy chi phí của từng bài học
  int _getLessonCost(int part) {
    switch (part) {
      case 2:
        return 100;
      case 3:
        return 200;
      default:
        return 0; // Phần 1 miễn phí
    }
  }
}
