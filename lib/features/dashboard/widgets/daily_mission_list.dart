// Widget hiển thị danh sách nhiệm vụ: Daily
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/mission_controller.dart';
import '../widgets/mission_card_widget.dart';

class DailyMissionList extends StatelessWidget {
  const DailyMissionList({super.key});

  @override
  Widget build(BuildContext context) {
    final missionCtrl = Provider.of<MissionController>(context);
    final missions = missionCtrl.dailyMissions;

    if (missions.isEmpty) {
      return const Center(child: Text('Không có nhiệm vụ'));
    }

    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) => MissionCardWidget(mission: missions[index]),
    );
  }
}