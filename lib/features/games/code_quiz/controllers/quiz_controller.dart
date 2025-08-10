import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../dashboard/controllers/streak_controller.dart';
import '../../../dashboard/controllers/mission_controller.dart';
import 'package:appta/features/games/code_quiz/controllers/lesson_progress_controller.dart'; // ✅ Thêm dòng này
import '../data/code_quiz_data.dart';

class QuizController extends ChangeNotifier {
  final String category; // code_quiz_1, code_quiz_2, ...
  late final List<Map<String, dynamic>> questions;

  int currentIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int correctCount = 0;
  int hearts = 3;

  QuizController(this.category) {
    // Lọc câu hỏi theo category
    questions = quizQuestions
        .where((q) => q['category'] == category)
        .toList();
  }

  void restoreHearts() {
    hearts = 3;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    if (!isAnswered) {
      selectedAnswer = answer;
      notifyListeners();
    }
  }

  bool confirmAnswer(BuildContext context) {
    isAnswered = true;
    final isCorrect =
        selectedAnswer == questions[currentIndex]['correctAnswer'];

    if (isCorrect) {
      correctCount++;

      // 📌 Cập nhật nhiệm vụ
      context.read<MissionController>().updateMissionProgress(
        context,
        'daily_correct_10',
      );

      // 📌 Cập nhật tiến độ học
      context.read<LessonProgressController>().increaseProgress(category);
    }

    notifyListeners();
    return isCorrect;
  }

  void nextQuestion(BuildContext context) {
    if (hearts <= 0) return;

    if (currentIndex < questions.length - 1) {
      currentIndex++;
      selectedAnswer = null;
      isAnswered = false;
      notifyListeners();
    } else {
      _showSummaryDialog(context);
    }
  }

  Future<void> _showSummaryDialog(BuildContext context) async {
    final streakCtrl = Provider.of<StreakController>(context, listen: false);
    await streakCtrl.updateStreak();

    // Cập nhật nhiệm vụ hoàn thành bài học
    context.read<MissionController>().updateMissionProgress(
      context,
      'daily_complete_lesson',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Hoàn thành"),
        content: Text(
          "Bạn đã trả lời đúng $correctCount / ${questions.length} câu.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void resetQuiz() {
    currentIndex = 0;
    correctCount = 0;
    selectedAnswer = null;
    isAnswered = false;
    notifyListeners();
  }
}
