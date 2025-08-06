import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/controllers/gem_controller.dart';
import '../../home/controllers/heart_controller.dart';

class HeartRecoveryDialog extends StatelessWidget {
  const HeartRecoveryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final gemCtrl = context.read<GemController>();
    final heartCtrl = context.read<HeartController>();

    return AlertDialog(
      title: const Text("Bạn đã hết tim 💔"),
      content: const Text("Bạn muốn đổi 50 💎 để nhận lại 1 tim và tiếp tục bài học không?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Thoát dialog
          child: const Text("Thoát"),
        ),
        TextButton(
          onPressed: () {
            if (gemCtrl.canAfford(50)) {
              gemCtrl.useGem(50);
              heartCtrl.restoreHeart(); // Thêm lại 1 tym
              Navigator.pop(context); // Đóng dialog
            } else {
              Navigator.pop(context); // Đóng dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Không đủ kim cương để tiếp tục 😢"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: const Text("Đồng ý"),
        ),
      ],
    );
  }
}
