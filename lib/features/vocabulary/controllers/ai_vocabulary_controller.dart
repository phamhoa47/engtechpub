/*import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/vocabulary_item.dart';

/// Enum dùng để xác định bộ lọc đang được chọn (Tất cả, Đã học, Chưa học, Yêu thích)
enum FilterType { all, learned, notLearned, favorite }

class AIVocabularyController extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  /// Danh sách từ vựng gốc (mock data tạm thời)
  List<VocabularyItem> items = [
    VocabularyItem(
      word: "Algorithm",
      pronunciation: "/ˈæl.ɡə.rɪ.ðəm/",
      meaning: "Thuật toán",
      example:
          "An algorithm is a step-by-step procedure for solving a problem.",
      exampleVi: "Thuật toán là một quy trình từng bước để giải quyết vấn đề.",
      imageUrl: "https://i.imgur.com/Zc5gX0m.png",
    ),
    VocabularyItem(
      word: "Neural Network",
      pronunciation: "/ˈnjʊə.rəl ˈnet.wɜːk/",
      meaning: "Mạng nơ-ron",
      example: "Neural networks are inspired by the human brain.",
      exampleVi: "Mạng nơ-ron được lấy cảm hứng từ bộ não con người.",
      imageUrl: "https://i.imgur.com/NJvA4Dn.png",
    ),
    VocabularyItem(
      word: "Dataset",
      pronunciation: "/ˈdeɪ.tə.set/",
      meaning: "Tập dữ liệu",
      example: "The model is trained on a large dataset.",
      exampleVi: "Mô hình được huấn luyện trên một tập dữ liệu lớn.",
      imageUrl: "https://i.imgur.com/Ki6V9r1.png",
    ),
    VocabularyItem(
      word: "Prediction",
      pronunciation: "/prɪˈdɪk.ʃən/",
      meaning: "Dự đoán",
      example: "The AI system provides accurate predictions.",
      exampleVi: "Hệ thống AI đưa ra các dự đoán chính xác.",
      imageUrl: "https://i.imgur.com/jvZnDnP.png",
    ),
    VocabularyItem(
      word: "Model",
      pronunciation: "/ˈmɒd.əl/",
      meaning: "Mô hình (máy học)",
      example: "We built a model to classify emails.",
      exampleVi: "Chúng tôi xây dựng một mô hình để phân loại email.",
      imageUrl: "https://i.imgur.com/njFvlR0.png",
    ),

    VocabularyItem(
      word: "Evaluation",
      pronunciation: "/ɪˌvæl.juˈeɪ.ʃən/",
      meaning: "Đánh giá (mô hình)",
      example: "The model's evaluation shows high precision.",
      exampleVi: "Việc đánh giá mô hình cho thấy độ chính xác cao.",
      imageUrl: "https://i.imgur.com/mCRDiCN.png",
    ),

    VocabularyItem(
      word: "Accuracy",
      pronunciation: "/ˈæk.jə.rə.si/",
      meaning: "Độ chính xác",
      example: "Accuracy is one of the most common metrics.",
      exampleVi: "Độ chính xác là một trong những chỉ số phổ biến nhất.",
      imageUrl: "https://i.imgur.com/HxKVsnL.png",
    ),

    VocabularyItem(
      word: "Label",
      pronunciation: "/ˈleɪ.bəl/",
      meaning: "Nhãn (trong dữ liệu gán nhãn)",
      example: "Each image in the dataset has a label.",
      exampleVi: "Mỗi hình ảnh trong tập dữ liệu đều có một nhãn.",
      imageUrl: "https://i.imgur.com/fK9ykzW.png",
    ),

    VocabularyItem(
      word: "Inference",
      pronunciation: "/ˈɪn.fər.əns/",
      meaning: "Suy diễn (khi mô hình đưa ra kết quả)",
      example: "The model runs inference in real-time.",
      exampleVi: "Mô hình thực hiện suy diễn theo thời gian thực.",
      imageUrl: "https://i.imgur.com/63NK89b.png",
    ),

    VocabularyItem(
      word: "Normalization",
      pronunciation: "/ˌnɔː.mə.laɪˈzeɪ.ʃən/",
      meaning: "Chuẩn hóa (dữ liệu)",
      example: "Normalization improves the model’s performance.",
      exampleVi: "Chuẩn hóa giúp cải thiện hiệu suất của mô hình.",
      imageUrl: "https://i.imgur.com/mJkgWwJ.png",
    ),
  ];

  /// Trạng thái tìm kiếm hiện tại (text trong ô tìm kiếm)
  String searchQuery = '';

  /// Trạng thái bộ lọc hiện tại (mặc định là Tất cả)
  FilterType currentFilter = FilterType.all;

  /// Cập nhật bộ lọc khi người dùng chọn tab lọc
  void setFilter(FilterType filter) {
    currentFilter = filter;
    notifyListeners();
  }

  /// Cập nhật text tìm kiếm từ người dùng
  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  /// Toggle trạng thái yêu thích của 1 từ
  void toggleFavorite(VocabularyItem item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  /// Toggle trạng thái đã học của 1 từ
  void toggleLearned(VocabularyItem item) {
    item.isLearned = !item.isLearned;
    notifyListeners();
  }

  /// Trả về danh sách đã lọc theo trạng thái (yêu thích, đã học, v.v...) và tìm kiếm
  List<VocabularyItem> get filteredItems {
    return items.where((item) {
      final matchesSearch =
          item.word.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.meaning.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesFilter = switch (currentFilter) {
        FilterType.all => true,
        FilterType.learned => item.isLearned,
        FilterType.notLearned => !item.isLearned,
        FilterType.favorite => item.isFavorite,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  /// Đọc phát âm tiếng Anh bằng Text-To-Speech
  void speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1);
    await _tts.speak(text);
  }
}
*/