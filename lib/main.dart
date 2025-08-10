import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'routes/app_routes.dart';

// Screens
import 'features/home/screens/home_menu_screen.dart';
import 'features/auth/screens/login_screen.dart';

// Controllers
import 'features/home/controllers/lesson_unlock_controller.dart';
import 'features/dashboard/controllers/streak_controller.dart';
import 'core/user_status_controller.dart';
import 'features/vocabulary/controllers/vocabulary_controller.dart';
import 'features/home/controllers/heart_controller.dart';
import 'features/home/controllers/gem_controller.dart';
import 'features/dashboard/controllers/mission_controller.dart';
import 'features/games/code_quiz/controllers/lesson_progress_controller.dart';


// Theme
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

// Local Notifications
import 'features/profile/services/local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⏰ Timezone cho local notifications
  tz.initializeTimeZones();

  // 🔥 Khởi tạo Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("✅ Firebase initialized");
  } catch (e) {
    log("❌ Firebase init failed: $e");
  }

  // 🔔 Khởi tạo thông báo cục bộ (chỉ Android/iOS)
  if (!kIsWeb) {
    await LocalNotifications.init();
  }

  runApp(const FloEngTechApp());
}

class FloEngTechApp extends StatelessWidget {
  const FloEngTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LessonUnlockController()),
        ChangeNotifierProvider(create: (_) => UserStatusController()),
        ChangeNotifierProvider(create: (_) => StreakController()),
        ChangeNotifierProvider(create: (_) => HeartController()),
        ChangeNotifierProvider(create: (_) => GemController()),
        ChangeNotifierProvider(create: (_) => MissionController()),
        ChangeNotifierProvider(create: (_) => VocabularyController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LessonProgressController()), 

      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'FloEngTech',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: AppRoutes.getRoutes(),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                log('🔁 Auth state: ${snapshot.connectionState} | user: ${snapshot.data?.email}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  return const HomeMenuScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
