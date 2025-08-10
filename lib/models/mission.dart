class Mission {
  final String id; // ID duy nhất của nhiệm vụ
  final String title; // Tên hiển thị
  final String type; // 'daily' hoặc 'weekly'
  final int goal; // Mục tiêu cần đạt (số lần, số câu,...)
  int progress; // Tiến độ hiện tại
  final String rewardType; // 'heart' hoặc 'gem'
  final int rewardAmount; // Số lượng phần thưởng
  bool isCompleted; // Đã hoàn thành chưa
  bool isClaimed; // Đã nhận thưởng chưa

  Mission({
    required this.id,
    required this.title,
    required this.type,
    required this.goal,
    this.progress = 0,
    required this.rewardType,
    required this.rewardAmount,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  /// Text hiển thị tiến độ (VD: "3 / 5")
  String get progressText => '$progress / $goal';

  /// Tỷ lệ phần trăm tiến độ (0.0 - 1.0)
  double get progressPercent => (progress / goal).clamp(0.0, 1.0);

  /// Đủ điều kiện nhận thưởng nếu đã hoàn thành và chưa nhận
  bool get canClaim => isCompleted && !isClaimed;
}
