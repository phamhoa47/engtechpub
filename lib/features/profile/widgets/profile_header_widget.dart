import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfile user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(user.avatarUrl),
        ),
        const SizedBox(height: 10),
        Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
        Text(user.email, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
      ],
    );
  }
}
