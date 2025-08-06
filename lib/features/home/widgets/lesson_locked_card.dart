import 'package:flutter/material.dart';

class LessonLockedCard extends StatelessWidget {
  final String partTitle;
  final String description;
  final int diamondCost;
  final VoidCallback onUnlock;

  const LessonLockedCard({
    super.key,
    required this.partTitle,
    required this.description,
    required this.diamondCost,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Colors.white38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(partTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(description, style: const TextStyle(color: Colors.white60)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUnlock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.diamond, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('$diamondCost', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
