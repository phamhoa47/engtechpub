import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotAndResetPasswordScreen extends StatefulWidget {
  const ForgotAndResetPasswordScreen({super.key});

  @override
  State<ForgotAndResetPasswordScreen> createState() =>
      _ForgotAndResetPasswordScreenState();
}

class _ForgotAndResetPasswordScreenState
    extends State<ForgotAndResetPasswordScreen> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (emailController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ thông tin");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      _showMessage("Mật khẩu xác nhận không khớp");
      return;
    }
    if (newPasswordController.text.length < 6) {
      _showMessage("Mật khẩu phải ít nhất 6 ký tự");
      return;
    }

    try {
      setState(() => isLoading = true);
      final response = await http.post(
        Uri.parse("https://YOUR_BACKEND_URL/reset-password"),
        body: {
          "email": emailController.text.trim(),
          "newPassword": newPasswordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        _showMessage("✅ Đổi mật khẩu thành công");
        Navigator.pop(context);
      } else {
        _showMessage("❌ Lỗi: ${response.body}");
      }
    } catch (e) {
      _showMessage("Lỗi kết nối server: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên & Đặt lại mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}
