import 'package:flutter/material.dart';
import '../models/vocabulary_item.dart';

class VocabularyTile extends StatelessWidget {
  final VocabularyItem item;
  final VoidCallback onItemTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleLearned;
  final VoidCallback onSpeak;

  const VocabularyTile({
    super.key,
    required this.item,
    required this.onItemTap,
    required this.onToggleFavorite,
    required this.onToggleLearned,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hình ảnh minh họa
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Icon(item.icon, size: 40, color: Colors.blueGrey),
            ),
            const SizedBox(width: 12),

            // Từ vựng + Nghĩa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.word,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.meaning, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),

            // Các nút chức năng
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.blueAccent),
                  onPressed: onSpeak,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(
                    item.isLearned
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: onToggleLearned,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.star : Icons.star_border,
                    color: item.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: onToggleFavorite,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
