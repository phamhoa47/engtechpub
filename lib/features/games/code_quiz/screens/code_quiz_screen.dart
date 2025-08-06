import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/part1_quiz_controller.dart';
import '../../../home/controllers/heart_controller.dart';
import '../../../home/controllers/gem_controller.dart';
import '../../../dashboard/controllers/streak_controller.dart';
import '../../../dashboard/controllers/mission_controller.dart';
import '../../widgets/out_of_hearts_dialog.dart';

class CodeQuizScreen extends StatelessWidget {
  const CodeQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CodeQuizController()),
      ],
      // ✅ Bọc toàn bộ màn hình bằng WillPopScope để chặn hành vi back
      child: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Xác nhận thoát'),
              content: const Text('Bạn có chắc chắn muốn thoát khỏi bài luyện tập?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Ở lại'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Thoát'),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF0D47A1),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // ✅ Sửa nút quay lại để hiển thị hộp thoại xác nhận
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                final shouldExit = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận thoát'),
                    content: const Text('Bạn có chắc chắn muốn thoát khỏi bài luyện tập?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Ở lại'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Thoát'),
                      ),
                    ],
                  ),
                );
                if (shouldExit ?? false) {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Row(
              children: [
                const Text("Code Practice - Cơ bản"),
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
      ),
    );
  }
}

class QuizBody extends StatelessWidget {
  const QuizBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CodeQuizController>(
      builder: (context, controller, _) {
        final question = controller.questions[controller.currentIndex];

        return Column(
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
                style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(14),
                    color: fillColor,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isSelected ? Colors.orange : Colors.grey.shade300,
                        radius: 12,
                        child: Text(
                          String.fromCharCode(65 + (question['options'].indexOf(option) as int)),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(option, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              );
            }).toList(),

            const Spacer(),

            if (controller.isAnswered)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "💡 ${question['explanation']}",
                  style: const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
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
                          final isCorrect = controller.confirmAnswer(context);
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  controller.isAnswered ? "Tiếp tục" : "XÁC NHẬN",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
