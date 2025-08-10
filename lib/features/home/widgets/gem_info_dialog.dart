import 'package:flutter/material.dart';

class GemInfoDialog extends StatelessWidget {
  final int gemCount; // 🔹 Số lượng đá quý hiện tại
  final VoidCallback onGoToMissions; // 🔹 Hàm điều hướng sang màn nhiệm vụ

  const GemInfoDialog({
    super.key,
    required this.gemCount,
    required this.onGoToMissions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.diamond, color: Colors.cyan),
          SizedBox(width: 8),
          Text("Đá quý"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔸 Hiển thị số đá quý hiện có
          Text(
            "Bạn có $gemCount đá quý",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔸 Tiêu đề phụ
          const Text(
            "Cách kiếm đá quý:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 🔹 Các dòng thông tin kiếm gem
          _buildLine(Icons.task_alt, "Hoàn thành nhiệm vụ hàng ngày", "+10 đá quý"),
          _buildLine(Icons.local_fire_department, "Duy trì chuỗi học 7 ngày", "+50 đá quý"),
          _buildLine(Icons.star, "Hoàn thành bài học hoàn hảo", "+20 đá quý"),
        ],
      ),
      actions: [
        // 🔹 Nút điều hướng đến màn nhiệm vụ
        TextButton(
          onPressed: onGoToMissions,
          child: const Text("Đi đến nhiệm vụ"),
        ),

        // 🔹 Nút đóng dialog
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Đóng"),
        ),
      ],
    );
  }

  /// 🔧 Widget dòng đơn hiển thị 1 cách kiếm gem
  Widget _buildLine(IconData icon, String text, String reward) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
          Text(reward, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
