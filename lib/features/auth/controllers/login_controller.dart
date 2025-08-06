import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appta/firebase/auth_service.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = ValueNotifier<bool>(false);

  final AuthService _authService = AuthService();

  // Ẩn / hiện mật khẩu
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Đăng nhập với email & mật khẩu
  Future<void> login(BuildContext context) async {
    try {
      final user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Đăng nhập thành công"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tài khoản hoặc mật khẩu của bạn không đúng"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Đăng nhập với Google
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Đăng nhập Google thành công"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không thể đăng nhập bằng Google. Vui lòng thử lại."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Gửi email đặt lại mật khẩu
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📩 Email đặt lại mật khẩu đã được gửi."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Không tìm thấy tài khoản với email này."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Giải phóng tài nguyên
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
  }
}
