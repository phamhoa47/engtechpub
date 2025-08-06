// models/lesson_part.dart
class LessonPart {
  final String title;
  final String description;
  final int requiredDiamonds;
  bool isUnlocked;

  LessonPart({
    required this.title,
    required this.description,
    required this.requiredDiamonds,
    this.isUnlocked = false,
  });
}
