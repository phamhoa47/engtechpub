// Widget hiển thị danh sách nhiệm vụ: Weekly
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/mission_controller.dart';
import '../widgets/mission_card_widget.dart';

class WeeklyMissionList extends StatelessWidget {
  const WeeklyMissionList({super.key});

  @override
  Widget build(BuildContext context) {
    final missionCtrl = Provider.of<MissionController>(context);
    final missions = missionCtrl.weeklyMissions;

    if (missions.isEmpty) {
      return const Center(child: Text('Không có nhiệm vụ'));
    }

    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) => MissionCardWidget(mission: missions[index]),
    );
  }
}
