import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appta/features/auth/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).cardColor,
                child: Icon(Icons.person, size: 40, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: textTheme.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  labelStyle: textTheme.bodyMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).iconTheme.color),
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: controller.isPasswordVisible,
                builder: (context, isVisible, _) {
                  return TextField(
                    controller: controller.passwordController,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      labelStyle: textTheme.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).iconTheme.color),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: Text(
                    "Forgot Password?",
                    style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.login(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Sign In",
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("Or continue with", style: textTheme.bodyMedium),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).cardColor,
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    onPressed: () => controller.loginWithGoogle(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "Sign Up",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}