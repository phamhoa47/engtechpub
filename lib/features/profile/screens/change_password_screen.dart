import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (!_formKey.currentState!.validate() || user == null) return;

    setState(() => isLoading = true);

    try {
      // ✅ Bước 1: Xác thực lại với mật khẩu hiện tại
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);

      // ✅ Bước 2: Đổi mật khẩu mới
      await user.updatePassword(newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đổi mật khẩu thành công")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu hiện tại"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nhập mật khẩu hiện tại" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu mới"),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Mật khẩu phải ≥ 6 ký tự";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Xác nhận mật khẩu mới"),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return "Mật khẩu không khớp";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _changePassword,
                      child: const Text("Cập nhật mật khẩu"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
