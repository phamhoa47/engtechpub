import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/mission.dart';
import '../controllers/mission_controller.dart';

class MissionCardWidget extends StatelessWidget {
  final Mission mission;

  const MissionCardWidget({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final missionCtrl = Provider.of<MissionController>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              mission.rewardType == 'heart' ? Icons.favorite : Icons.diamond,
              color: mission.rewardType == 'heart' ? Colors.red : Colors.blue,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: mission.progressPercent,
                    backgroundColor: Colors.grey.shade300,
                    color:
                        mission.isCompleted ? Colors.green : Colors.amber,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.progressText,
                    style: TextStyle(
                      fontSize: 13,
                      color: mission.isCompleted
                          ? Colors.green
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (mission.canClaim)
              ElevatedButton(
                onPressed: () {
                  missionCtrl.claimReward(context, mission.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text("Nhận thưởng 🎁"),
              )
            else if (mission.isClaimed)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}