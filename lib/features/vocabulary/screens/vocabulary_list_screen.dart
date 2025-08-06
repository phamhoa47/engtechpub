// lib/features/vocabulary/screens/vocabulary_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vocabulary_controller.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ✅ Import màn hình Flashcard
import 'vocabulary_flashcard_screen.dart';

class VocabularyListScreen extends StatefulWidget {
  final String topic; // Chủ đề từ vựng (ví dụ: AI, Backend, ...)
  const VocabularyListScreen({super.key, required this.topic});

  @override
  State<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  final FlutterTts tts = FlutterTts(); // Đọc từ vựng
  final TextEditingController searchController = TextEditingController(); // Ô tìm kiếm
  String selectedFilter = "Tất cả"; // Bộ lọc mặc định

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VocabularyController>(context);

    // 📌 Lấy danh sách từ theo chủ đề
    List<VocabularyItem> items = controller.getByTopic(widget.topic);

    // 📌 Lọc theo ô tìm kiếm
    if (searchController.text.isNotEmpty) {
      items = items.where((word) {
        return word.word.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ) ||
            word.meaning.toLowerCase().contains(
              searchController.text.toLowerCase(),
            );
      }).toList();
    }

    // 📌 Lọc theo trạng thái học
    if (selectedFilter == "Đã học") {
      items = items.where((word) => word.isLearned).toList();
    } else if (selectedFilter == "Chưa học") {
      items = items.where((word) => !word.isLearned).toList();
    } else if (selectedFilter == "Yêu thích") {
      items = items.where((word) => word.isFavorite).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Tìm từ hoặc nghĩa...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // 🎯 Bộ lọc trạng thái học
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Tất cả", "Đã học", "Chưa học", "Yêu thích"]
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (_) =>
                              setState(() => selectedFilter = filter),
                          selectedColor: Colors.green.shade100,
                          labelStyle: TextStyle(
                            color: selectedFilter == filter
                                ? Colors.green.shade800
                                : Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 📜 Danh sách từ vựng
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("Không tìm thấy từ vựng"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final word = items[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          // 📌 Khi bấm vào từ → mở Flashcard từ vị trí hiện tại
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VocabularyFlashcardPage(
                                  items: items,       // Danh sách từ
                                  initialIndex: index, // Vị trí bắt đầu
                                ),
                              ),
                            );
                          },
                          title: Text(
                            word.word,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            word.meaning,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              await tts.setLanguage("en-US");
                              await tts.setPitch(1);
                              await tts.speak(word.word);
                            },
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              // ✅ Đánh dấu đã học
                              IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: word.isLearned
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  controller.toggleLearned(word);
                                },
                              ),
                              // ⭐ Yêu thích
                              IconButton(
                                icon: Icon(
                                  word.isFavorite
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  controller.toggleFavorite(word);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
