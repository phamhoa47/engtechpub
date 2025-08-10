import 'package:flutter/material.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class VocabularyReviewScreen extends StatefulWidget {
  final List<VocabularyItem> items;
  const VocabularyReviewScreen({super.key, required this.items});

  @override
  State<VocabularyReviewScreen> createState() => _VocabularyReviewScreenState();
}

class _VocabularyReviewScreenState extends State<VocabularyReviewScreen> {
  int currentIndex = 0;
  List<VocabularyItem> stillWrong = [];

  void markAsKnown() {
    if (currentIndex < widget.items.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      showFinishDialog();
    }
  }

  void markAsUnknown() {
    stillWrong.add(widget.items[currentIndex]);
    if (currentIndex < widget.items.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      showFinishDialog();
    }
  }

  void showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Ôn tập xong"),
        content: Text(
          stillWrong.isEmpty
              ? "Tuyệt vời! Bạn đã thuộc tất cả các từ sai."
              : "Bạn vẫn chưa thuộc ${stillWrong.length} từ. Hãy luyện lại nhé!",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Về Home"),
          ),
          if (stillWrong.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VocabularyReviewScreen(items: stillWrong),
                  ),
                );
              },
              child: const Text("Học lại từ chưa thuộc"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.items.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "Không có từ nào để ôn lại 🎉",
            style: theme.textTheme.titleMedium,
          ),
        ),
      );
    }

    final item = widget.items[currentIndex];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1B2A49) : const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Học lại từ sai"),
        backgroundColor: isDark ? Colors.teal : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Từ ${currentIndex + 1}/${widget.items.length}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // Flashcard hiển thị từ
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF243B5A) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.tealAccent : Colors.blue,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.word,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.pronunciation,
                      style: TextStyle(
                        color: isDark ? Colors.tealAccent : Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.meaning,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nút đánh dấu
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: markAsUnknown,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Chưa thuộc",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: markAsKnown,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Đã thuộc",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
