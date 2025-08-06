import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakController extends ChangeNotifier {
  int streak = 0;
  DateTime? lastActiveDate;

  Future<void> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    streak = prefs.getInt('streak') ?? 0;
    final lastDateStr = prefs.getString('lastActiveDate');
    if (lastDateStr != null) {
      lastActiveDate = DateTime.tryParse(lastDateStr);
    }
    notifyListeners();
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();

    if (lastActiveDate == null) {
      streak = 1;
    } else {
      final difference = today.difference(lastActiveDate!).inDays;
      if (difference == 1) {
        streak++;
      } else if (difference > 1) {
        streak = 1;
      }
    }

    lastActiveDate = today;
    await prefs.setInt('streak', streak);
    await prefs.setString('lastActiveDate', today.toIso8601String());

    notifyListeners();
  }
}
