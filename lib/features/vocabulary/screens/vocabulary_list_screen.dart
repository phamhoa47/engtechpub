import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:appta/features/vocabulary/models/vocabulary_item.dart';
import 'package:appta/features/vocabulary/controllers/vocabulary_controller.dart';
import 'vocabulary_flashcard_screen.dart';
import 'package:appta/utils/game_menu_helper.dart';

class VocabularyListScreen extends StatefulWidget {
  final String topic;
  const VocabularyListScreen({super.key, required this.topic});

  @override
  State<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  final FlutterTts tts = FlutterTts();
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "Tất cả"; // ✅ Giá trị mặc định

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Nhận dữ liệu filter từ arguments (nếu có)
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('filter')) {
      final filterArg = args['filter'] as String;
      setState(() {
        selectedFilter = filterArg == "chua_hoc"
            ? "Chưa học"
            : filterArg == "da_hoc"
                ? "Đã học"
                : filterArg == "yeu_thich"
                    ? "Yêu thích"
                    : "Tất cả";
      });
    }
  }

  List<VocabularyItem> _applyFilters(
    VocabularyController controller,
    String topic,
  ) {
    List<VocabularyItem> items = controller.getByTopic(topic);

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      items = items.where((word) {
        return word.word.toLowerCase().contains(query) ||
            word.meaning.toLowerCase().contains(query);
      }).toList();
    }

    switch (selectedFilter) {
      case "Đã học":
        items = items.where((word) => word.isLearned).toList();
        break;
      case "Chưa học":
        items = items.where((word) => !word.isLearned).toList();
        break;
      case "Yêu thích":
        items = items.where((word) => word.isFavorite).toList();
        break;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VocabularyController>(context);
    final items = _applyFilters(controller, widget.topic);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final cardColor = isDark ? Colors.grey[800] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Chơi game từ vựng",
            icon: const Icon(Icons.videogame_asset, color: Colors.orange),
            onPressed: () {
              GameMenuHelper.show(context, items); // ✅ helper hiển thị menu game
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Tìm từ hoặc nghĩa...",
                hintStyle: TextStyle(color: subtitleColor),
                prefixIcon: Icon(Icons.search, color: subtitleColor),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
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

          // 🎯 Bộ lọc
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ["Tất cả", "Đã học", "Chưa học", "Yêu thích"]
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (_) =>
                            setState(() => selectedFilter = filter),
                        selectedColor: isDark
                            ? Colors.green.withOpacity(0.3)
                            : Colors.green.shade100,
                        labelStyle: TextStyle(
                          color: selectedFilter == filter
                              ? Colors.green.shade800
                              : textColor,
                        ),
                        backgroundColor:
                            isDark ? Colors.grey[700] : Colors.grey[200],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // 📜 Danh sách từ vựng
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      "Không tìm thấy từ vựng",
                      style: TextStyle(color: subtitleColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final word = items[index];
                      return Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VocabularyFlashcardPage(
                                  items: items,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            word.word,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            word.meaning,
                            style: TextStyle(color: subtitleColor),
                          ),
                          leading: IconButton(
                            icon: Icon(
                              Icons.volume_up,
                              color: isDark ? Colors.blue[200] : Colors.blue,
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
                              IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: word.isLearned
                                      ? Colors.green
                                      : subtitleColor,
                                ),
                                onPressed: () {
                                  controller.toggleLearned(word);
                                },
                              ),
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
