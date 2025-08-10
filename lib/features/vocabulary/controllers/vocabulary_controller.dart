import 'package:flutter/material.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'package:appta/features/vocabulary/data/vocabulary_data.dart'; // 📌 Import dữ liệu

class VocabularyController extends ChangeNotifier {
  String searchQuery = '';

  // 📌 Lấy dữ liệu từ file data
  final List<VocabularyItem> items = vocabularyData;

  // 🔍 Cập nhật từ khóa tìm kiếm
  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // 🔍 Lấy kết quả tìm kiếm
  List<VocabularyItem> get filteredItems {
    if (searchQuery.isEmpty) return [];
    return items.where((item) {
      return item.word.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.meaning.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // 📌 Lấy từ vựng theo chủ đề
  List<VocabularyItem> getByTopic(String topic) {
    return items.where((item) => item.topic == topic).toList();
  }

  // ❤️ Đổi trạng thái yêu thích
  void toggleFavorite(VocabularyItem item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  // 📚 Đổi trạng thái đã học
  void toggleLearned(VocabularyItem item) {
    item.isLearned = !item.isLearned;
    notifyListeners();
  }
}
