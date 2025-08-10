import 'package:flutter/material.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'package:appta/features/games/game_quiz/vocabulary_quiz_screen.dart';
import 'package:appta/features/games/word_sprint_game/word_sprint_screen.dart';
import 'package:appta/features/games/ListeningChallenge/listening_challenge_screen.dart'; // <-- Import mới

class GameMenuHelper {
  static void show(BuildContext context, List<VocabularyItem> items) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🎮 Chọn chế độ chơi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Quiz
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.blueAccent),
                title: const Text("Quiz từ vựng"),
                subtitle: const Text("Trả lời câu hỏi chọn nghĩa đúng"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VocabularyQuizScreen(items: items),
                    ),
                  );
                },
              ),
              const Divider(),

              // Word Sprint
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.redAccent),
                title: const Text("Word Sprint"),
                subtitle: const Text("Chạy đua với thời gian để chọn nghĩa đúng"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WordSprintScreen(items: items),
                    ),
                  );
                },
              ),
              const Divider(),

              // Listening Challenge (Game mới)
              ListTile(
                leading: const Icon(Icons.hearing, color: Colors.teal),
                title: const Text("Listening Challenge"),
                subtitle: const Text("Nghe từ và chọn đáp án đúng"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListeningChallengeScreen(items: items),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
