import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/quiz_controller.dart';
import '../../../home/controllers/heart_controller.dart';
import '../controllers/lesson_progress_controller.dart';
import '../../../dashboard/controllers/mission_controller.dart';
import '../../widgets/out_of_hearts_dialog.dart';
import 'package:appta/utils/exit_confirm_dialog.dart'; // ✅ Import dialog mới

class CodeQuizScreen extends StatelessWidget {
  final String category;
  const CodeQuizScreen({super.key, required this.category});

  String get partId {
    if (category == 'code_quiz_1') return 'phan_1';
    if (category == 'code_quiz_2') return 'phan_2';
    return 'phan_3';
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizController(category)),
        ChangeNotifierProvider(create: (_) => LessonProgressController()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0D47A1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldExit = await ExitConfirmDialog.show(
                context,
                message: 'Bạn có chắc chắn muốn thoát khỏi bài luyện tập?',
              );
              if (shouldExit ?? false) Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Text(
                category == "code_quiz_1"
                    ? "Code Practice - Cơ bản"
                    : category == "code_quiz_2"
                        ? "Code Practice - Nâng cao"
                        : "Code Practice - Chuyên sâu",
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Consumer<HeartController>(
                builder: (_, heartCtrl, __) => Row(
                  children: List.generate(
                    3,
                    (index) => Icon(
                      Icons.favorite,
                      color:
                          index < heartCtrl.hearts ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: QuizBody(partId: partId),
        ),
      ),
    );
  }
}

class QuizBody extends StatelessWidget {
  final String partId;
  const QuizBody({super.key, required this.partId});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (_, controller, __) {
        final question = controller.questions[controller.currentIndex];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Câu ${controller.currentIndex + 1}/${controller.questions.length}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
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
                    fontFamily: 'monospace',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
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
                            String.fromCharCode(
                              65 +
                                  (question['options'] as List<String>)
                                      .indexOf(option),
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 12),
              if (controller.isAnswered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "💡 ${question['explanation']}",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedAnswer == null
                      ? null
                      : () {
                          final heartCtrl = context.read<HeartController>();
                          if (!controller.isAnswered) {
                            final isCorrect =
                                controller.confirmAnswer(context);
                            if (isCorrect) {
                              context
                                  .read<LessonProgressController>()
                                  .increaseProgress(partId);
                            } else {
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}