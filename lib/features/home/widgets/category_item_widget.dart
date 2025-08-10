import 'package:flutter/material.dart';
import '../controllers/home_menu_controller.dart';
import '../../vocabulary/screens/vocabulary_list_screen.dart'; // 🟢 Import màn từ vựng

class CategoryItemWidget extends StatelessWidget {
  final TopicCategory category;

  const CategoryItemWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent, width: 2),
      ),
      child: InkWell(
        onTap: () {
          // 🆕 Khi bấm vào ô, truyền luôn topic sang VocabularyListScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VocabularyListScreen(topic: category.name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 36, color: Colors.amber),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
