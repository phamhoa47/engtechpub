class UserProgress {
  int streakDays;
  DateTime lastStudyDate;

  UserProgress({
    required this.streakDays,
    required this.lastStudyDate,
  });

  factory UserProgress.initial() {
    return UserProgress(
      streakDays: 0,
      lastStudyDate: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void updateStreak(DateTime currentDate) {
    if (isSameDay(currentDate, lastStudyDate)) {
      // đã học hôm nay rồi → không cập nhật
      return;
    }

    final yesterday = currentDate.subtract(const Duration(days: 1));

    if (isSameDay(yesterday, lastStudyDate)) {
      // học liên tiếp → tăng chuỗi
      streakDays++;
    } else {
      // bị ngắt → reset
      streakDays = 1;
    }

    lastStudyDate = currentDate;
  }
}
