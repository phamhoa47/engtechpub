import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/part2_quiz_controller.dart';
import '../../../home/controllers/heart_controller.dart';
import '../../../home/controllers/gem_controller.dart';
import '../../widgets/out_of_hearts_dialog.dart';

class CodeQuiz2Screen extends StatelessWidget {
  const CodeQuiz2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CodeQuiz2Controller()),
        // HeartController và GemController đã được inject ở main.dart
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0D47A1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: Row(
            children: [
              const Text("Code Practice - Part 2"),
              const Spacer(),
              Consumer<HeartController>(
                builder: (context, heartCtrl, _) => Row(
                  children: List.generate(
                    3,
                    (index) => Icon(
                      Icons.favorite,
                      color: index < heartCtrl.hearts ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: QuizBody(),
        ),
      ),
    );
  }
}

class QuizBody extends StatelessWidget {
  const QuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CodeQuiz2Controller, HeartController>(
      builder: (context, controller, heartCtrl, _) {
        final question = controller.questions[controller.currentIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nội dung có thể cuộn
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Câu ${controller.currentIndex + 1}/${controller.questions.length}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),

                    // Code block
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3A59),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        question['code'],
                        style: const TextStyle(
                            fontFamily: 'monospace', color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Câu hỏi
                    Text(
                      question['question'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 16),

                    // Lựa chọn
                    ...question['options'].map<Widget>((option) {
                      final isSelected = controller.selectedAnswer == option;
                      final isCorrect = option == question['correctAnswer'];
                      Color borderColor = Colors.grey.shade300;
                      Color fillColor = Colors.white;

                      if (controller.isAnswered) {
                        if (isSelected && isCorrect) {
                          borderColor = Colors.green;
                          fillColor = Colors.green.shade50;
                        } else if (isSelected && !isCorrect) {
                          borderColor = Colors.red;
                          fillColor = Colors.red.shade50;
                        } else if (isCorrect) {
                          borderColor = Colors.green;
                        }
                      } else if (isSelected) {
                        borderColor = Colors.orange;
                        fillColor = Colors.orange.shade50;
                      }

                      return GestureDetector(
                        onTap: () => controller.selectAnswer(option),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(14),
                            color: fillColor,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isSelected
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                                radius: 12,
                                child: Text(
                                  String.fromCharCode(65 +
                                      (question['options'].indexOf(option)
                                          as int)),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(option,
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 16),

                    if (controller.isAnswered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "💡 ${question['explanation']}",
                          style: const TextStyle(
                              color: Colors.yellow, fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Nút xác nhận / tiếp tục cố định
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.selectedAnswer == null || heartCtrl.isOutOfHearts
                    ? null
                    : () {
                        if (!controller.isAnswered) {
                          final isCorrect = controller.confirmAnswer();
                          if (!isCorrect) {
                            heartCtrl.loseHeart();
                            if (heartCtrl.isOutOfHearts) {
                              showDialog(
                                context: context,
                                builder: (_) => const OutOfHeartsDialog(),
                              );
                            }
                          }
                        } else {
                          controller.nextQuestion(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  controller.isAnswered ? "Tiếp tục" : "XÁC NHẬN",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
