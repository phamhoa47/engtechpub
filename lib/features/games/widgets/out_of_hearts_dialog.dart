import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/controllers/gem_controller.dart';
import '../../home/controllers/heart_controller.dart';

class OutOfHeartsDialog extends StatelessWidget {
  const OutOfHeartsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final gemController = context.read<GemController>();
    final heartController = context.read<HeartController>();
    bool canBuyHeart = gemController.gems >= 50;

    return AlertDialog(
      title: const Text("Bạn đã hết tym"),
      content: Text(
        canBuyHeart
          ? "Bạn có muốn đổi 50 💎 để tiếp tục?"
          : "Bạn không đủ đá quý để tiếp tục.",
      ),
      actions: [
        if (canBuyHeart)
          TextButton(
            onPressed: () {
              gemController.useGem(50);
              heartController.restoreHeart();
              Navigator.pop(context);
            },
            child: const Text("Đổi 50💎"),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Đóng dialog
            Navigator.pop(context); // Thoát quiz
          },
          child: const Text("Thoát"),
        ),
      ],
    );
  }
}
