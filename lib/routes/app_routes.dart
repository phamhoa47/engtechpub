import 'package:flutter/material.dart';

// Screens
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/home/screens/home_menu_screen.dart';
import '../features/games/code_quiz/screens/code_quiz_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/vocabulary/screens/vocabulary_list_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String aiVocabulary = '/ai-vocabulary';
  static const String codeQuiz = '/quiz-code';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeMenuScreen(),
      aiVocabulary: (context) => const VocabularyListScreen(topic: "AI"),
      profile: (context) => const ProfileScreen(),

      // ✅ Quiz có truyền category qua arguments
      codeQuiz: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        // Gán mặc định nếu không có category
        final category = args?['category'] ?? 'code_quiz_1';

        return CodeQuizScreen(category: category);
      },
    };
  }
}
