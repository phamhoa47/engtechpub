/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/ai_vocabulary_controller.dart';
import '../models/vocabulary_item.dart';
import '../screens/vocabulary_flashcard_screen.dart';
import '../widgets/vocabulary_tile.dart';

class AIVocabularyScreen extends StatelessWidget {
  const AIVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AIVocabularyController(),
      child: Consumer<AIVocabularyController>(
        builder: (context, controller, _) {
          final words = controller.filteredItems;

          return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "AI Vocabulary",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 1,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔎 Search bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: controller.updateSearch,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      hintText: 'Tìm từ hoặc nghĩa...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 🔘 Bộ lọc: Tất cả / Đã học / Chưa học / Yêu thích
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: FilterType.values.map((filter) {
                      final isSelected = controller.currentFilter == filter;
                      final text = switch (filter) {
                        FilterType.all => 'Tất cả',
                        FilterType.learned => 'Đã học',
                        FilterType.notLearned => 'Chưa học',
                        FilterType.favorite => 'Yêu thích',
                      };
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => controller.setFilter(filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.green : Colors.white,
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                // 📋 Danh sách từ vựng
                Expanded(
                  child: words.isEmpty
                      ? const Center(child: Text("Không tìm thấy từ nào"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: words.length,
                          itemBuilder: (context, index) {
                            final item = words[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: VocabularyTile(
                                item: item,
                                onItemTap: () {
                                  final filtered = controller.filteredItems;
                                  final index = filtered.indexOf(item);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VocabularyFlashcardPage(
                                        items: filtered,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                onToggleLearned: () =>
                                    controller.toggleLearned(item),
                                onToggleFavorite: () =>
                                    controller.toggleFavorite(item),
                                onSpeak: () => controller.speak(item.word),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/