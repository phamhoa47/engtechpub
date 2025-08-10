import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFE3F2FD), // Nền xanh pastel nhạt
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1976D2), // Xanh dương đậm
      foregroundColor: Colors.white,     // Màu chữ AppBar
    ),
    iconTheme: const IconThemeData(color: Color(0xFF1976D2)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF37474F)),      // Xám đậm nhẹ (blue grey)
      bodyMedium: TextStyle(color: Color(0xFF455A64)),     // Blue Grey nhẹ
      titleLarge: TextStyle(color: Color(0xFF5C6BC0)),     // Tím pastel (indigo lighten)
      labelLarge: TextStyle(color: Color(0xFF42A5F5)),     // Xanh pastel cho nút
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1976D2),
      secondary: Color(0xFFF38BA0),
      surface: Colors.white,
      onSurface: Color(0xFF37474F), // Màu chữ trên bề mặt
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // ✅ FIX: chuyển về Brightness.dark
    scaffoldBackgroundColor: const Color(0xFF1B2A49), // Nền xanh navy pastel
    cardColor: const Color(0xFF243B5A),               // Thẻ màu lam nhạt
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF162447),
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF9AEBA3)), // Icon xanh pastel
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFB2EBF2)),     // Xanh pastel
      bodyMedium: TextStyle(color: Color(0xFFB3E5FC)),    // Xanh nước pastel
      titleLarge: TextStyle(color: Color(0xFFCE93D8)),    // Tím hồng pastel
      labelLarge: TextStyle(color: Color(0xFFF48FB1)),    // Nút màu hồng pastel
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9AEBA3),
      secondary: Color(0xFFF38BA0),
      surface: Color(0xFF243B5A),
      onSurface: Color.fromARGB(255, 8, 52, 58), // Màu chữ trên bề mặt
    ),
  );
}
