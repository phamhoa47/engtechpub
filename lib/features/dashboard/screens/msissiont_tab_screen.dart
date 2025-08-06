import 'package:flutter/material.dart';
import '../widgets/daily_mission_list.dart';
import '../widgets/weekly_mission_list.dart';

class MissionTabScreen extends StatelessWidget {
  const MissionTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nhiệm vụ 🎯"),
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Hàng ngày"),
              Tab(text: "Hàng tuần"),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFFDF6FB),
        body: const TabBarView(
          children: [
            DailyMissionList(),
            WeeklyMissionList(),
          ],
        ),
      ),
    );
  }
}