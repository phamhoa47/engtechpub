import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart'; // ✅ import ForgotPasswordScreen
import '../features/home/screens/home_menu_screen.dart';
import '../features/vocabulary/screens/ai_vocabulary_screen.dart'; 
import '../features/games/code_quiz/screens/code_quiz_screen.dart'; 
import '../features/games/code_quiz/screens/code_quiz_2_screen.dart'; 
import '../features/profile/screens/profile_screen.dart'; 
import 'package:appta/features/vocabulary/screens/vocabulary_list_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password'; // ✅ thêm hằng số route

  static const String home = '/home';
  static const String aiVocabulary = '/ai-vocabulary'; 
  static const String codeQuizBasic = '/quiz-code-basic';
  static const String codeQuizPart2 = '/quiz-code-part-2';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(), // ✅ route Forgot Password
      home: (context) => const HomeMenuScreen(),
      aiVocabulary: (context) => const VocabularyListScreen(topic: "AI"),
      codeQuizBasic: (context) => const CodeQuizScreen(),
      codeQuizPart2: (context) => const CodeQuiz2Screen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
