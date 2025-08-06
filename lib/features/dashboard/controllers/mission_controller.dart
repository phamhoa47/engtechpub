import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/mission.dart'; // 🧩 Model Mission gồm id, title, type, goal, progress,...
import '../../home/controllers/heart_controller.dart'; // ❤️ Controller quản lý số tym
import '../../home/controllers/gem_controller.dart'; // 💎 Controller quản lý kim cương

class MissionController extends ChangeNotifier {
  // 🌟 Danh sách tất cả các nhiệm vụ (bao gồm daily và weekly)
  final List<Mission> _missions = [];

  // ✅ Constructor: Tự động khởi tạo danh sách nhiệm vụ mặc định
  MissionController() {
    _loadInitialMissions();
  }

  // ✅ Thêm các nhiệm vụ mặc định vào danh sách
  void _loadInitialMissions() {
    _missions.addAll([
      // 🟡 Nhiệm vụ hàng ngày
      Mission(
        id: 'daily_complete_lesson',
        title: 'Hoàn thành 1 bài học',
        type: 'daily',
        goal: 1,
        rewardType: 'heart', // 🎁 Thưởng: tym
        rewardAmount: 1,
      ),
      Mission(
        id: 'daily_correct_10',
        title: 'Trả lời đúng 10 câu',
        type: 'daily',
        goal: 10,
        rewardType: 'gem', // 🎁 Thưởng: gem
        rewardAmount: 3,
      ),

      // 🔵 Nhiệm vụ hàng tuần
      Mission(
        id: 'weekly_perfect_3_lessons',
        title: 'Hoàn thành 3 bài học hoàn hảo',
        type: 'weekly',
        goal: 3,
        rewardType: 'gem',
        rewardAmount: 10,
      ),
      Mission(
        id: 'weekly_login_7_days',
        title: 'Đăng nhập đủ 7 ngày',
        type: 'weekly',
        goal: 7,
        rewardType: 'heart',
        rewardAmount: 2,
      ),
    ]);
  }

  // ✅ Lấy danh sách nhiệm vụ hàng ngày
  List<Mission> get dailyMissions =>
      _missions.where((m) => m.type == 'daily').toList();

  // ✅ Lấy danh sách nhiệm vụ hàng tuần
  List<Mission> get weeklyMissions =>
      _missions.where((m) => m.type == 'weekly').toList();

  // ✅ Lấy toàn bộ nhiệm vụ (gộp daily + weekly) — dùng cho update
  List<Mission> get allMissions => _missions;

  // ✅ Cập nhật tiến độ nhiệm vụ theo `missionId`, có thể tăng `value` mặc định là 1
  void updateMissionProgress(BuildContext context, String missionId,
      {int value = 1}) {
    final mission = _missions.firstWhere((m) => m.id == missionId);
    if (mission.isCompleted) return;

    // Tăng tiến độ
    mission.progress += value;

    // Đánh dấu hoàn thành nếu đủ mục tiêu
    if (mission.progress >= mission.goal) {
      mission.progress = mission.goal;
      mission.isCompleted = true;
    }

    notifyListeners();
  }

  // ✅ Nhận phần thưởng sau khi hoàn thành nhiệm vụ
  void claimReward(BuildContext context, String missionId) {
    final mission = _missions.firstWhere((m) => m.id == missionId);

    // Nếu chưa đủ điều kiện nhận thưởng thì bỏ qua
    if (!mission.canClaim) return;

    mission.isClaimed = true;

    // ✅ Cộng phần thưởng đúng controller với số lượng
    if (mission.rewardType == 'heart') {
      context.read<HeartController>().addHeart();
    } else if (mission.rewardType == 'gem') {
      context.read<GemController>().addGems(mission.rewardAmount);
    }

    notifyListeners();
  }

  // ✅ Reset lại nhiệm vụ hàng ngày (dùng vào mỗi 0h hoặc login mới)
  void resetDailyMissions() {
    for (var m in _missions.where((m) => m.type == 'daily')) {
      m.progress = 0;
      m.isCompleted = false;
      m.isClaimed = false;
    }
    notifyListeners();
  }

  // ✅ Reset lại nhiệm vụ hàng tuần (dùng vào mỗi Chủ nhật hoặc theo thời gian)
  void resetWeeklyMissions() {
    for (var m in _missions.where((m) => m.type == 'weekly')) {
      m.progress = 0;
      m.isCompleted = false;
      m.isClaimed = false;
    }
    notifyListeners();
  }
}
