import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../services/local_notifications.dart';
import 'edit_profile_screen.dart';
import 'package:appta/features/vocabulary/data/vocabulary_data.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _testReminderEnabled = false;
  bool _dailyReminderEnabled = false;

  VocabularyItem? wordOfTheDay;

  @override
  void initState() {
    super.initState();
    _getWordOfTheDay(); // ✅ lấy từ ngẫu nhiên mỗi ngày
  }

  void _getWordOfTheDay() {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    setState(() {
      wordOfTheDay = vocabularyData[random.nextInt(vocabularyData.length)];
    });
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Thông tin cá nhân ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? "Người dùng",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? "",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                       
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );

                      if (result == true) {
                        setState(() {}); // reload lại profile
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- Học tập & Tiến trình ---
          _buildCard(
            context,
            title: "Học tập & Tiến trình",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 📘 Từ vựng hôm nay
                if (wordOfTheDay != null) ...[
                  const Text(
                    "📘 Từ vựng hôm nay:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${wordOfTheDay!.word} – ${wordOfTheDay!.meaning}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],

                const SizedBox(height: 12),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- Cài đặt học tập ---
          _buildCard(
            context,
            title: "Cài đặt học tập",
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("NHẮC LỊCH HỌC"),
                  value: _testReminderEnabled,
                  onChanged: (bool val) async {
                    setState(() {
                      _testReminderEnabled = val;
                      if (val) _dailyReminderEnabled = false;
                    });

                    if (val) {
                      final randomWord = (vocabularyData..shuffle()).first;
                      await LocalNotifications.showDailyScheduleNotification(
                        title: "EngTech nhắc em ",
                        body:
                            "💡 ${randomWord.word} nghĩa là ${randomWord.meaning} — học ngay hôm nay nhé!",
                        payload: "study_reminder_test",
                        isTest: true,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Đã bật nhắc học")),
                      );
                    } else {
                      await LocalNotifications.cancel(3);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Đã tắt nhắc học")),
                      );
                    }
                  },
                ),

                SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: themeProvider.isDarkMode,
                  onChanged: (val) {
                    themeProvider.toggleTheme(val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- Thành tích ---
          
        

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text("Đăng xuất"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
