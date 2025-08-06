import 'package:flutter/material.dart';

class RegisterController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  void register(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage(context, 'Please fill in all fields');
    } else if (password != confirm) {
      _showMessage(context, 'Passwords do not match');
    } else {
      // TODO: Implement register logic
      _showMessage(context, 'Registered successfully as $email');
      Navigator.pop(context);
    }
  }

  void dispose() {
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
