import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../vocabulary/models/vocabulary_item.dart';

class WordSprintScreen extends StatefulWidget {
  final List<VocabularyItem> items;
  const WordSprintScreen({super.key, required this.items});

  @override
  State<WordSprintScreen> createState() => _WordSprintScreenState();
}

class _WordSprintScreenState extends State<WordSprintScreen> {
  int currentIndex = 0;
  int score = 0;
  double timeLeft = 1.0;
  Timer? timer;
  bool isAnswered = false;
  String? selectedAnswer;
  late List<String> currentOptions;

  late ConfettiController _confettiController;

  // 5 giây mỗi câu → giảm 0.01 mỗi 50ms
  final double decreasePerTick = 0.01;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    currentOptions = getOptions(widget.items[currentIndex]);
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 1.0;
    timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      setState(() {
        timeLeft -= decreasePerTick;
        if (timeLeft <= 0) {
          t.cancel();
          handleTimeout();
        }
      });
    });
  }

  void handleTimeout() {
    setState(() {
      isAnswered = true;
    });

    showAnswerPopup(false, widget.items[currentIndex].meaning);

    Future.delayed(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  List<String> getOptions(VocabularyItem correctItem) {
    final options = [correctItem.meaning];
    final shuffled = [...widget.items]..shuffle();

    for (var item in shuffled) {
      if (options.length < 4 && item.meaning != correctItem.meaning) {
        options.add(item.meaning);
      }
    }

    options.shuffle();
    return options;
  }

  void selectAnswer(String option, String correct) {
    if (isAnswered) return;
    setState(() {
      selectedAnswer = option;
      isAnswered = true;
    });

    if (option == correct) {
      score++;
      showAnswerPopup(true, correct);
    } else {
      showAnswerPopup(false, correct);
    }

    timer?.cancel();

    Future.delayed(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentIndex < widget.items.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        selectedAnswer = null;
        currentOptions = getOptions(widget.items[currentIndex]);
      });
      startTimer();
    } else {
      showResult();
    }
  }

  void showAnswerPopup(bool isCorrect, String correctAnswer) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.35,
        left: MediaQuery.of(context).size.width * 0.15,
        right: MediaQuery.of(context).size.width * 0.15,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCorrect ? "Chính xác rồi nhé hẹ hẹ !" : " Sai rồi bảnh ơi!",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Đáp án đúng: $correctAnswer",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 1200), () {
      entry.remove();
    });
  }

  void showResult() {
    timer?.cancel();
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.orange, Colors.pink],
          ),
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "🎉 Hoàn thành!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Bạn đã trả lời đúng $score / ${widget.items.length} câu.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentIndex = 0;
                    score = 0;
                    isAnswered = false;
                    selectedAnswer = null;
                    currentOptions = getOptions(widget.items[0]);
                  });
                  startTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Làm lại"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Về Home"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[currentIndex];
    final options = currentOptions;

    return Scaffold(
      backgroundColor: Colors.white,
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
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Điểm: $score",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Thanh thời gian
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: timeLeft,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${(timeLeft * 5).toStringAsFixed(1)}s còn lại",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              // Thẻ từ vựng
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 1),
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
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.volume_up, color: Colors.green),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Đáp án
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    bool isSelected = selectedAnswer == option;
                    bool isCorrect = isAnswered && option == item.meaning;
                    bool isWrong = isAnswered && isSelected && option != item.meaning;

                    Color bgColor = Colors.white;
                    if (isCorrect) bgColor = Colors.green.shade200;
                    if (isWrong) bgColor = Colors.red.shade200;
                    if (isSelected && !isAnswered) bgColor = Colors.blue.shade100;

                    return GestureDetector(
                      onTap: () => selectAnswer(option, item.meaning),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 1),
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
            ],
          ),
        ),
      ),
    );
  }
}
