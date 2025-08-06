import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';

import 'package:appta/features/home/screens/home_menu_screen.dart';
import 'package:appta/features/auth/screens/login_screen.dart';
import 'package:appta/features/home/controllers/lesson_unlock_controller.dart';
import 'package:appta/features/dashboard/controllers/streak_controller.dart';
import 'package:appta/core/controllers/user_status_controller.dart';
import 'package:appta/features/games/code_quiz/controllers/part1_quiz_controller.dart';
import 'package:appta/features/vocabulary/controllers/vocabulary_controller.dart'; // ✅ Thêm
import 'features/home/controllers/heart_controller.dart';
import 'features/home/controllers/gem_controller.dart';
import 'features/dashboard/controllers/mission_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log("✅ Firebase initialized successfully");
    } else {
      log("ℹ️ Firebase already initialized");
    }
  } catch (e) {
    log("❌ Firebase init error: $e");
  }

  if (Platform.isIOS) {
    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;
      socket.send([1, 2, 3], InternetAddress("255.255.255.255"), 8000);
      socket.close();
      log("✅ Local network socket sent");
    } catch (e) {
      log("❌ Local network error: $e");
    }
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
        ChangeNotifierProvider(create: (_) => CodeQuizController()),
        ChangeNotifierProvider(create: (_) => HeartController()),
        ChangeNotifierProvider(create: (_) => GemController()),
        ChangeNotifierProvider(create: (_) => MissionController()),
        ChangeNotifierProvider(create: (_) => VocabularyController()), // ✅ Thêm
      ],
      child: MaterialApp(
        title: 'FloEngTech',
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.getRoutes(),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const HomeMenuScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
