import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appta/features/games/code_quiz/controllers/lesson_progress_controller.dart';
import 'package:appta/features/home/controllers/lesson_unlock_controller.dart';
import 'package:appta/features/games/code_quiz/screens/code_quiz_screen.dart';

class LearningCardWidget extends StatelessWidget {
  final String title;
  final int part;
  final int total;

  const LearningCardWidget({
    super.key,
    required this.title,
    required this.part,
    this.total = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<LessonUnlockController, LessonProgressController>(
      builder: (context, unlockCtrl, progressCtrl, _) {
        final isUnlocked = unlockCtrl.isUnlocked(part);
        final cost = unlockCtrl.costToUnlock(part);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00C853), width: 2),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Text("📘", style: TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 16),

              // Nội dung bên trái (chỉ tiêu đề, không thanh tiến trình)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Nút "Tiếp tục" hoặc "Mua"
              ElevatedButton(
                onPressed: () {
                  if (isUnlocked) {
                    final category = 'code_quiz_$part';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CodeQuizScreen(category: category),
                      ),
                    );
                  } else {
                    unlockCtrl.tryUnlockLesson(context, part);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUnlocked ? const Color(0xFF00C853) : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isUnlocked ? "Tiếp tục" : "Mua ($cost💎)",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
