import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dashboard/controllers/streak_controller.dart';

class StreakDialog extends StatelessWidget {
  const StreakDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<StreakController>().streak;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF37474F),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$streak ngày streak 🔥',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 12),
            const Text("Bạn đang có chuỗi streak dài nhất từ trước tới nay!",
                style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: i == 0 ? Colors.orange : Colors.grey.shade700,
                  child: i == 0
                      ? const Icon(Icons.local_fire_department, size: 16, color: Colors.white)
                      : null,
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              "Duy trì chuỗi học liên tục để nhận thưởng!\nNếu bỏ lỡ 1 ngày, chuỗi sẽ bị reset về 0.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => Navigator.pop(context),
              child: const Text("ĐÓNG", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
