import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/mission_controller.dart';
import 'package:appta/features/dashboard/widgets/daily_mission_list.dart';
import 'package:appta/features/dashboard/widgets/weekly_mission_list.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text(
            'Nhiệm vụ 🏆',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Hàng ngày'),
              Tab(text: 'Hàng tuần'),
            ],
          ),
        ),
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