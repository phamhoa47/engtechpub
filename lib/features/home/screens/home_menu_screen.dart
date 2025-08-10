import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 📦 Import các controller và widget cần thiết
import 'package:appta/features/home/controllers/home_menu_controller.dart';
import 'package:appta/features/home/widgets/category_item_widget.dart';
import 'package:appta/features/games/code_quiz/widget/learning_card_widget.dart';
import 'package:appta/features/dashboard/controllers/streak_controller.dart';
import 'package:appta/features/dashboard/widgets/streak_dialog.dart';
import 'package:appta/features/home/controllers/lesson_unlock_controller.dart';
import 'package:appta/features/home/controllers/gem_controller.dart';
import 'package:appta/features/home/widgets/gem_info_dialog.dart';
import 'package:appta/features/home/controllers/heart_controller.dart';
import 'package:appta/features/dashboard/controllers/mission_controller.dart';
import 'package:appta/models/mission.dart';
import 'package:appta/features/profile/screens/profile_screen.dart';
import 'package:appta/theme/theme_provider.dart';

import 'package:appta/features/dashboard/screens/mission_screen.dart';
import 'package:appta/features/dashboard/screens/daily_mission_screen.dart';

import 'package:appta/features/vocabulary/controllers/vocabulary_controller.dart';
import 'package:appta/features/vocabulary/screens/vocabulary_list_screen.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    final vocabCtrl = Provider.of<VocabularyController>(context);
    final searchResults = vocabCtrl.filteredItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                        : [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
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
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.titleLarge?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
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
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.color,
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
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge?.color,
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
                          Text(
                            "Chicken",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Học tiếng Anh cùng chú gà con!",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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
                        color: Theme.of(context).cardColor,
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
                                Text(
                                  "Nhiệm vụ hàng ngày",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  dailyMission.title,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
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
                          Icon(
                            Icons.card_giftcard,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
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
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        item.word,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Text(
                        "${item.meaning} • ${item.topic}",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "English for IT Majors",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
              Text(
                "Bài học chính",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              LearningCardWidget(title: "Phần 1", part: 1),
              LearningCardWidget(title: "Phần 2", part: 2),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Theme.of(context).iconTheme.color,
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
