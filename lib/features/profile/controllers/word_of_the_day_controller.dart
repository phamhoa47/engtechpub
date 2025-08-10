import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class WordOfTheDayController extends ChangeNotifier {
  VocabularyItem? _wordOfTheDay;

  VocabularyItem? get wordOfTheDay => _wordOfTheDay;

  Future<void> loadWordOfTheDay(List<VocabularyItem> vocabulary) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateTime.now().toIso8601String().substring(0, 10);

    final savedWord = prefs.getString('word_of_day_$todayKey');
    if (savedWord != null) {
      _wordOfTheDay = vocabulary.firstWhere(
        (item) => item.word == savedWord,
        orElse: () => vocabulary.first,
      );
    } else {
      final unlearned = vocabulary.where((w) => !w.isLearned).toList();
      if (unlearned.isNotEmpty) {
        final randomWord = unlearned[Random().nextInt(unlearned.length)];
        _wordOfTheDay = randomWord;
        await prefs.setString('word_of_day_$todayKey', randomWord.word);
      }
    }
    notifyListeners();
  }

  void markAsLearned() {
    if (_wordOfTheDay != null) {
      _wordOfTheDay!.isLearned = true;
      notifyListeners();
    }
  }
}
