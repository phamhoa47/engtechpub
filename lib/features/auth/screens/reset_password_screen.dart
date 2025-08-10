import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  Future<void> _updatePassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ thông tin");
      return;
    }
    if (newPass.length < 6) {
      _showMessage("Mật khẩu mới phải từ 6 ký tự trở lên");
      return;
    }
    if (newPass != confirmPass) {
      _showMessage("Mật khẩu xác nhận không khớp");
      return;
    }

    try {
      setState(() => isLoading = true);

      // Gọi API backend đổi mật khẩu
      final url = Uri.parse("http://localhost:3000/reset-password"); // Thay bằng URL backend thật
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "newPassword": newPass,
        }),
      );

      if (response.statusCode == 200) {
        _showMessage("✅ Đổi mật khẩu thành công");
        Navigator.pop(context); // Quay lại màn login
      } else {
        _showMessage("❌ Lỗi: ${response.body}");
      }
    } catch (e) {
      _showMessage("Lỗi kết nối: $e");
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
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        title: const Text("Đặt lại mật khẩu"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${widget.email}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Ô nhập mật khẩu mới
            TextField(
              controller: newPasswordController,
              obscureText: !isNewPasswordVisible,
              decoration: InputDecoration(
                labelText: "Mật khẩu mới",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isNewPasswordVisible = !isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ô nhập lại mật khẩu mới
            TextField(
              controller: confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Xác nhận ",
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
