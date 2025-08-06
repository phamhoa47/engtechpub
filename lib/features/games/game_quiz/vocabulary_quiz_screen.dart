import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appta/features/home/controllers/heart_controller.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class VocabularyQuizScreen extends StatefulWidget {
  final List<VocabularyItem> items;
  const VocabularyQuizScreen({super.key, required this.items});

  @override
  State<VocabularyQuizScreen> createState() => _VocabularyQuizScreenState();
}

class _VocabularyQuizScreenState extends State<VocabularyQuizScreen> {
  int currentQuestion = 0; // Câu hỏi hiện tại
  String? selectedAnswer;  // Đáp án người dùng chọn
  bool isAnswered = false; // Đã trả lời hay chưa

  late List<List<String>> allOptions; // Danh sách đáp án cho từng câu

  @override
  void initState() {
    super.initState();

    // 🔹 Tạo 4 đáp án ngẫu nhiên cho mỗi câu
    allOptions = widget.items.map((item) {
      List<String> options = [item.meaning];
      List<String> otherMeanings = widget.items
          .where((i) => i.meaning != item.meaning)
          .map((i) => i.meaning)
          .toList();
      otherMeanings.shuffle();
      options.addAll(otherMeanings.take(3));
      options.shuffle();
      return options;
    }).toList();
  }

  // 📌 Kiểm tra đáp án
  void checkAnswer() {
    final heartController = context.read<HeartController>();
    final correctAnswer = widget.items[currentQuestion].meaning;

    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn một đáp án")),
      );
      return;
    }

    setState(() {
      isAnswered = true;
    });

    if (selectedAnswer != correctAnswer) {
      heartController.loseHeart(); // Mất tim nếu sai
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sai rồi! Đáp án đúng là: $correctAnswer")),
      );
    }
  }

  // 📌 Chuyển sang câu hỏi tiếp theo hoặc kết thúc
  void nextQuestion() {
    if (currentQuestion < widget.items.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        isAnswered = false;
      });
    } else {
      // Hết câu hỏi → Hiển thị kết quả
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bo góc
            ),
            title: const Text("🎉 Hoàn thành!", textAlign: TextAlign.center),
            content: const Text("Bạn đã hoàn thành quiz", textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestion = 0;
                    selectedAnswer = null;
                    isAnswered = false;
                  });
                },
                child: const Text("🔄 Chơi lại"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("🏠 Về Home"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[currentQuestion];
    final options = allOptions[currentQuestion];
    final heartController = context.watch<HeartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // 🌟 Nền xanh dương nhạt
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16), // Padding chung
          child: Column(
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút thoát
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Hiển thị tim
                  

                  // Hiển thị số câu
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Nền xanh
                      borderRadius: BorderRadius.circular(20), // Bo góc
                    ),
                    child: Text(
                      "Điểm: $currentQuestion", // Có thể thay bằng biến điểm thật
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // 🔹 Thanh tiến trình
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  children: [
                    Text(
                      "Câu hỏi ${currentQuestion + 1}/${widget.items.length}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (currentQuestion + 1) / widget.items.length,
                      backgroundColor: Colors.blue.shade100,
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ],
                ),
              ),

              // 🔹 Thẻ câu hỏi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Nền trắng
                  borderRadius: BorderRadius.circular(16), // Bo góc
                  border: Border.all(color: Colors.blue, width: 1), // Viền xanh
                ),
                child: Column(
                  children: [
                    const Text(
                      "Nghĩa của từ này là gì?",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.word,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.pronunciation,
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.blue),
                      onPressed: () {
                        // 📌 Play sound
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Danh sách đáp án
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    bool isSelected = selectedAnswer == option;
                    bool isCorrect = isAnswered && option == item.meaning;
                    bool isWrong = isAnswered && isSelected && option != item.meaning;

                    Color bgColor = Colors.white;
                    if (isCorrect) bgColor = Colors.green.shade300;
                    if (isWrong) bgColor = Colors.red.shade300;
                    if (isSelected && !isAnswered) bgColor = Colors.blue.shade200;

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
                          borderRadius: BorderRadius.circular(12), // Bo góc
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 Nút xác nhận / tiếp tục
              ElevatedButton(
                onPressed: () {
                  if (!isAnswered) {
                    checkAnswer();
                  } else {
                    nextQuestion();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Nền xanh
                  foregroundColor: Colors.white, // Chữ trắng
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc
                  ),
                ),
                child: Text(isAnswered ? "Tiếp tục" : "Xác nhận"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
