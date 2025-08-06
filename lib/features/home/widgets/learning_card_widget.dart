import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appta/features/home/controllers/lesson_unlock_controller.dart';
import 'package:appta/features/games/code_quiz/screens/code_quiz_screen.dart';
import 'package:appta/features/games/code_quiz/screens/code_quiz_2_screen.dart';
// import thêm nếu có part 3...

class LearningCardWidget extends StatelessWidget {
  final String title;
  final int part;
  final int progress;
  final int total;

  const LearningCardWidget({
    super.key,
    required this.title,
    required this.part,
    this.progress = 0,
    this.total = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonUnlockController>(
      builder: (context, unlockCtrl, _) {
        final bool isUnlocked = unlockCtrl.isUnlocked(part);
        final double progressValue = (progress / total).clamp(0.0, 1.0);
        final int cost = unlockCtrl.costToUnlock(part);

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

              // 🔹 NỘI DUNG CHÍNH
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
                    const SizedBox(height: 6),
                    Text(
                      '$progress / $total bài',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF607D8B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: isUnlocked ? progressValue : 0,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // 🔸 NÚT "TIẾP TỤC" HOẶC "MUA"
              ElevatedButton(
                onPressed: () {
                  if (isUnlocked) {
                    // ✅ Điều hướng theo part
                    switch (part) {
                      case 1:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CodeQuizScreen()));
                        break;
                      case 2:
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CodeQuiz2Screen()));
                        break;
                      case 3:
                        // TODO: Thêm quiz screen cho part 3 nếu có
                        break;
                    }
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
              ),
            ],
          ),
        );
      },
    );
  }
}
