import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage(context, 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (password != confirm) {
      _showMessage(context, 'Mật khẩu không khớp');
      return;
    }

    if (password.length < 6) {
      _showMessage(context, 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      await userCredential.user?.sendEmailVerification();

      _showMessage(context, 'Đăng ký thành công! Vui lòng xác minh email');
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} - ${e.message}');
      String message = 'Đã xảy ra lỗi không xác định';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email đã được đăng ký';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ';
          break;
        case 'weak-password':
          message = 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
          break;
        case 'operation-not-allowed':
          message = 'Chức năng đăng ký chưa được bật trên Firebase';
          break;
        case 'network-request-failed':
          message = 'Không có kết nối Internet';
          break;
        default:
          message = e.message ?? message;
      }
      _showMessage(context, message);
    } catch (e) {
      log('Exception: $e');
      _showMessage(context, 'Có lỗi không xác định xảy ra');
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
