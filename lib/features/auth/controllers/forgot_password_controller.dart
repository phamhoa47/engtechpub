import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController {
  final emailController = TextEditingController();

  Future<void> sendResetRequest(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(context, 'Vui lòng nhập email');
      return;
    }
    if (!email.contains("@")) {
      _showMessage(context, 'Email không hợp lệ');
      return;
    }

    try {
      // Gọi API backend thay vì Firebase
      final url = Uri.parse('https://your-api.com/reset-password');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        _showMessage(context, 'Đã gửi yêu cầu đặt lại mật khẩu cho $email');
        Navigator.pop(context);
      } else {
        _showMessage(context, 'Email chưa được đăng ký hoặc không hợp lệ');
      }
    } catch (e) {
      _showMessage(context, 'Lỗi: ${e.toString()}');
    }
  }

  void dispose() {
    emailController.dispose();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
