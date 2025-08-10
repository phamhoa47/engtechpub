import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'listening_challenge_controller.dart';

class ListeningChallengeScreen extends StatelessWidget {
  final List<VocabularyItem> items;
  const ListeningChallengeScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListeningChallengeController(items),
      child: const _ListeningChallengeBody(),
    );
  }
}

class _ListeningChallengeBody extends StatelessWidget {
  const _ListeningChallengeBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ListeningChallengeController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final item = controller.currentItem;
    final options = controller.currentOptions;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1B2A49) : const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: theme.iconTheme.color),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Câu hỏi + tiến trình
              Text(
                "Câu hỏi ${controller.currentIndex + 1}/${controller.items.length}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (controller.currentIndex + 1) / controller.items.length,
                backgroundColor: isDark ? Colors.white12 : Colors.blue.shade100,
                valueColor: AlwaysStoppedAnimation(
                  isDark ? Colors.tealAccent : Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Khung nghe phát âm (câu hỏi)
              Container(
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
                  children: [
                    Text(
                      "Nghe phát âm và chọn đáp án đúng:",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: controller.speak,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.teal.shade700 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.volume_up, color: isDark ? Colors.tealAccent : Colors.blue, size: 28),
                            const SizedBox(width: 8),
                            Text("Nghe", style: TextStyle(
                              color: isDark ? Colors.tealAccent : Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Danh sách đáp án
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    bool isSelected = controller.selectedAnswer == option;
                    bool isCorrect = controller.isAnswered && option == item.word;
                    bool isWrong = controller.isAnswered && isSelected && !isCorrect;

                    Color bgColor = isDark ? const Color(0xFF2E4C6D) : Colors.white;
                    if (isCorrect) bgColor = Colors.green.shade400;
                    if (isWrong) bgColor = Colors.red.shade400;
                    if (isSelected && !controller.isAnswered) {
                      bgColor = isDark ? Colors.teal.shade400 : Colors.blue.shade200;
                    }

                    return GestureDetector(
                      onTap: controller.isAnswered
                          ? null
                          : () => controller.selectAnswer(option),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.tealAccent : Colors.blue,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Hiện đáp án đúng (sau khi xác nhận)
              if (controller.isAnswered) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.teal.shade900 : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.teal,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Đáp án đúng: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '${item.word}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: ' — ${item.meaning}',
                                style: TextStyle(
                                  color: isDark ? Colors.tealAccent : Colors.teal.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Nút xác nhận / tiếp tục
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (!controller.isAnswered) {
                      controller.checkAnswer();
                    } else {
                      if (!controller.isLastQuestion) {
                        controller.nextQuestion();
                      } else {
                        showResultDialog(context, controller);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.tealAccent : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    controller.isAnswered
                        ? (controller.isLastQuestion ? "Kết thúc" : "Tiếp tục")
                        : "Xác nhận",
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Dialog kết quả cuối cùng
  void showResultDialog(BuildContext context, ListeningChallengeController controller) {
    int totalQuestions = controller.items.length;
    int score = controller.correctCount * 10;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎧 Kết quả Listening Challenge"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Số câu đúng: ${controller.correctCount} / $totalQuestions"),
            Text("Số câu sai: ${controller.wrongCount}"),
            Text("Điểm số: $score"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Về Home
            },
            child: const Text("Về Home"),
          )
        ],
      ),
    );
  }
}
