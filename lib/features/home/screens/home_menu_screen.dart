import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📦 Import các controller và widget cần thiết
import 'package:appta/features/home/controllers/home_menu_controller.dart';
import 'package:appta/features/home/widgets/category_item_widget.dart';
import 'package:appta/features/home/widgets/learning_card_widget.dart';
import 'package:appta/features/dashboard/controllers/streak_controller.dart';
import 'package:appta/features/dashboard/widgets/streak_dialog.dart';
import 'package:appta/features/home/controllers/lesson_unlock_controller.dart';
import 'package:appta/features/home/controllers/gem_controller.dart';
import 'package:appta/features/home/widgets/gem_info_dialog.dart';
import 'package:appta/features/home/controllers/heart_controller.dart';
import 'package:appta/features/dashboard/controllers/mission_controller.dart';
import 'package:appta/models/mission.dart';
import 'package:appta/features/profile/screens/profile_screen.dart';

// 🟢 Sửa ở đây: sử dụng MissionScreen thay vì DailyMissionScreen
import 'package:appta/features/dashboard/screens/mission_screen.dart';
import 'package:appta/features/dashboard/screens/daily_mission_screen.dart';

// 🆕 Import controller quản lý từ vựng
import 'package:appta/features/vocabulary/controllers/vocabulary_controller.dart';
import 'package:appta/features/vocabulary/screens/vocabulary_list_screen.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  int _selectedIndex = 0;

  // ✅ Điều hướng tab dưới
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Điều hướng tới MissionScreen - Tab nhiệm vụ
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MissionScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = HomeMenuController();

    // 🆕 Lấy controller từ vựng để hỗ trợ tìm kiếm
    final vocabCtrl = Provider.of<VocabularyController>(context);
    final searchResults = vocabCtrl.filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 🔵 HEADER (Streak, Heart, Gem)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // 🔥 Streak
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const StreakDialog(),
                                  );
                                },
                                child: Consumer<StreakController>(
                                  builder: (context, streakCtrl, _) => Row(
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${streakCtrl.streak}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // ❤️ Heart + 💎 Gem
                              Consumer2<HeartController, GemController>(
                                builder: (context, heartCtrl, gemCtrl, _) =>
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.redAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${heartCtrl.hearts}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => GemInfoDialog(
                                                gemCount: gemCtrl.gems,
                                                onGoToMissions: () {
                                                  Navigator.pop(context);
                                                  _onTabTapped(1);
                                                },
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.diamond,
                                                color: Colors.cyanAccent,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${gemCtrl.gems}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Chicken",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Học tiếng Anh cùng chú gà con!",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🟣 KHỐI NHIỆM VỤ HÀNG NGÀY - GỢI NHỚ
              Consumer<MissionController>(
                builder: (context, missionCtrl, _) {
                  final dailyMission = missionCtrl.dailyMissions.firstWhere(
                    (m) => m.id == 'daily_correct_10',
                    orElse: () => Mission(
                      id: '',
                      title: '',
                      type: 'daily',
                      goal: 1,
                      rewardType: 'gem',
                      rewardAmount: 0,
                    ),
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailyMissionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF263238),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt, color: Colors.amber, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nhiệm vụ hàng ngày",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  dailyMission.title,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: dailyMission.progressPercent,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.amber,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.card_giftcard,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🆕 Thanh tìm kiếm từ vựng
              TextField(
                decoration: InputDecoration(
                  hintText: "Tìm từ vựng...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: vocabCtrl.updateSearch,
              ),
              const SizedBox(height: 16),

              // 🆕 Nếu có kết quả tìm kiếm thì hiển thị danh sách kết quả
              if (searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return ListTile(
                      leading: Icon(
                        item.icon,
                        size: 40,
                        color: Colors.blueGrey,
                      ),
                      title: Text(item.word),
                      subtitle: Text("${item.meaning} • ${item.topic}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VocabularyListScreen(topic: item.topic),
                          ),
                        );
                      },
                    );
                  },
                )
              else
                // 🟡 CHỦ ĐỀ
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "English for IT Majors",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: controller.topicCategories
                          .map(
                            (category) =>
                                CategoryItemWidget(category: category),
                          )
                          .toList(),
                    ),
                  ],
                ),

              const SizedBox(height: 28),

              // 🟢 BÀI HỌC CHÍNH
              const Text(
                "Bài học chính",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LearningCardWidget(
                title: "Phần 1",
                part: 1,
                progress: 0,
                total: 10,
              ),
              LearningCardWidget(
                title: "Phần 2",
                part: 2,
                progress: 0,
                total: 10,
              ),
              LearningCardWidget(
                title: "Phần 3",
                part: 3,
                progress: 0,
                total: 10,
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),

      // 🔻 BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        backgroundColor: const Color(0xFF263238),
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HỌC"),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "NHIỆM VỤ",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "HỒ SƠ"),
        ],
      ),
    );
  }
}
