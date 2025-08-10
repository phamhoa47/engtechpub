import 'package:flutter/material.dart';

class VocabularyItem {
  int? id; // SQLite ID
  final String word;
  final String pronunciation;
  final String meaning;
  final String example;
  final String exampleVi;
  final IconData icon; // 🆕 Thay imageUrl bằng IconData
  final String topic;
  bool isFavorite;
  bool isLearned;

  VocabularyItem({
    this.id,
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.example,
    required this.exampleVi,
    required this.icon,
    required this.topic,
    this.isFavorite = false,
    this.isLearned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'example': example,
      'exampleVi': exampleVi,
      'iconCode': icon.codePoint, // 🆕 lưu mã icon
      'iconFontFamily': icon.fontFamily, // 🆕 lưu font
      'topic': topic,
      'isFavorite': isFavorite ? 1 : 0,
      'isLearned': isLearned ? 1 : 0,
    };
  }

  factory VocabularyItem.fromMap(Map<String, dynamic> map) {
    return VocabularyItem(
      id: map['id'],
      word: map['word'],
      pronunciation: map['pronunciation'],
      meaning: map['meaning'],
      example: map['example'],
      exampleVi: map['exampleVi'],
      icon: IconData(
        map['iconCode'],
        fontFamily: map['iconFontFamily'],
      ),
      topic: map['topic'],
      isFavorite: map['isFavorite'] == 1,
      isLearned: map['isLearned'] == 1,
    );
  }
}
