import 'package:flutter/material.dart';
import '../widgets/daily_mission_list.dart'; // ✅ Import widget đã tách riêng

class DailyMissionScreen extends StatelessWidget {
  const DailyMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhiệm vụ hàng ngày 🎯"),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: const Color(0xFFFDF6FB),
      body: const DailyMissionList(), // ✅ Dùng lại widget đã tách
    );
  }
}
