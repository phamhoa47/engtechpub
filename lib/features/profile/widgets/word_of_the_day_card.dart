import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'package:appta/features/profile/controllers/word_of_the_day_controller.dart';

class WordOfTheDayCard extends StatelessWidget {
  const WordOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<WordOfTheDayController>(context);
    final word = controller.wordOfTheDay;

    if (word == null) return const SizedBox.shrink();

    return Card(
      color: Colors.blue.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📘 Từ vựng hôm nay", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(word.word,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {
                    FlutterTts().speak(word.word);
                  },
                ),
              ],
            ),
            Text(word.meaning, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text("📎 ${word.example}", style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.markAsLearned(),
              icon: const Icon(Icons.check),
              label: const Text("Đánh dấu đã học"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
