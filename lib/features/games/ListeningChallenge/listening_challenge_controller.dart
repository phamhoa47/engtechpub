import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../vocabulary/models/vocabulary_item.dart';

class ListeningChallengeController extends ChangeNotifier {
  final List<VocabularyItem> items;
  int currentIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int correctCount = 0;
  int wrongCount = 0;

  final FlutterTts tts = FlutterTts();

  late List<List<String>> optionsList;

  ListeningChallengeController(this.items) {
    // Tạo danh sách options ngẫu nhiên cho mỗi câu hỏi
    optionsList = items.map((item) {
      List<String> options = [item.word];
      List<String> others = items
          .where((i) => i.word != item.word)
          .map((i) => i.word)
          .toList();
      others.shuffle();
      options.addAll(others.take(3));
      options.shuffle();
      return options;
    }).toList();
  }

  List<String> get currentOptions => optionsList[currentIndex];
  VocabularyItem get currentItem => items[currentIndex];

  Future<void> speak() async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.4);
    await tts.speak(currentItem.word);
  }

  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  void checkAnswer() {
    isAnswered = true;
    if (selectedAnswer == currentItem.word) {
      correctCount++;
    } else {
      wrongCount++;
    }
    notifyListeners();
  }

  bool get isLastQuestion => currentIndex == items.length - 1;

  void nextQuestion() {
    if (!isLastQuestion) {
      currentIndex++;
      selectedAnswer = null;
      isAnswered = false;
      notifyListeners();
    }
  }

  void reset() {
    currentIndex = 0;
    selectedAnswer = null;
    isAnswered = false;
    correctCount = 0;
    wrongCount = 0;
    notifyListeners();
  }
}
