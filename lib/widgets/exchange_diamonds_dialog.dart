import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_status_provider.dart';

class ExchangeDiamondsDialog extends StatelessWidget {
  const ExchangeDiamondsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bạn đã hết tim ❤️"),
      content: const Text("Bạn muốn đổi 50 đá quý để nhận 1 tim và tiếp tục học?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Kết thúc"),
        ),
        Consumer<UserStatusProvider>(
          builder: (_, user, __) => ElevatedButton(
            onPressed: () {
              if (user.useDiamonds(50)) {
                user.gainHeart();
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không đủ đá quý!")),
                );
              }
            },
            child: const Text("Đổi 50💎 để tiếp tục"),
          ),
        )
      ],
    );
  }
}
