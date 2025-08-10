import 'package:flutter/material.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class VocabularyQuizScreen extends StatefulWidget {
  final List<VocabularyItem> items;
  const VocabularyQuizScreen({super.key, required this.items});

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  int currentQuestion = 0;
  String? selectedAnswer;
  bool isAnswered = false;

  late List<List<String>> allOptions;

  // Thêm biến đếm đúng/sai
  int correctAnswers = 0;
  int wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    allOptions = widget.items.map((item) {
      List<String> options = [item.meaning];
      List<String> others = widget.items
          .where((i) => i.meaning != item.meaning)
          .map((i) => i.meaning)
          .toList();
      others.shuffle();
      options.addAll(others.take(3));
      options.shuffle();
      return options;
    }).toList();
  }

  void checkAnswer() {
    final correctAnswer = widget.items[currentQuestion].meaning;

    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn một đáp án")),
      );
      return;
    }

    setState(() {
      isAnswered = true;
      if (selectedAnswer == correctAnswer) {
        correctAnswers++;
      } else {
        wrongAnswers++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sai rồi! Đáp án đúng là: $correctAnswer")),
        );
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < widget.items.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        isAnswered = false;
      });
    } else {
      showResultDialog();
    }
  }

  // Hiển thị kết quả quiz
  void showResultDialog() {
    int totalQuestions = widget.items.length;
    int score = correctAnswers * 10; // 10 điểm mỗi câu đúng

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Kết quả Quiz"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Số câu đúng: $correctAnswers / $totalQuestions"),
            Text("Số câu sai: $wrongAnswers"),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final item = widget.items[currentQuestion];
    final options = allOptions[currentQuestion];

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
                "Câu hỏi ${currentQuestion + 1}/${widget.items.length}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (currentQuestion + 1) / widget.items.length,
                backgroundColor: isDark ? Colors.white12 : Colors.blue.shade100,
                valueColor: AlwaysStoppedAnimation(
                  isDark ? Colors.tealAccent : Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Thẻ câu hỏi
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
                      "Nghĩa của từ này là gì?",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.word,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.pronunciation,
                      style: TextStyle(
                        color: isDark ? Colors.tealAccent : Colors.blue,
                        fontSize: 16,
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
                    bool isSelected = selectedAnswer == option;
                    bool isCorrect = isAnswered && option == item.meaning;
                    bool isWrong = isAnswered && isSelected && !isCorrect;

                    Color bgColor = isDark ? const Color(0xFF2E4C6D) : Colors.white;
                    if (isCorrect) bgColor = Colors.green.shade400;
                    if (isWrong) bgColor = Colors.red.shade400;
                    if (isSelected && !isAnswered) {
                      bgColor = isDark ? Colors.teal.shade400 : Colors.blue.shade200;
                    }

                    return GestureDetector(
                      onTap: isAnswered
                          ? null
                          : () {
                              setState(() {
                                selectedAnswer = option;
                              });
                            },
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

              // Nút xác nhận / tiếp tục
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (!isAnswered) {
                      checkAnswer();
                    } else {
                      nextQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.tealAccent : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isAnswered ? "Tiếp tục" : "Xác nhận",
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
}
