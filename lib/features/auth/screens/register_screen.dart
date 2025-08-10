import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // ✅ Tạo tài khoản Firebase
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // ✅ Cập nhật tên người dùng vào Firebase Auth
        await userCredential.user?.updateDisplayName(nameController.text.trim());
        await userCredential.user?.reload();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tạo tài khoản thành công!")),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String message = "Có lỗi xảy ra";
        if (e.code == 'email-already-in-use') {
          message = "Email đã được đăng ký";
        } else if (e.code == 'invalid-email') {
          message = "Email không hợp lệ";
        } else if (e.code == 'weak-password') {
          message = "Mật khẩu quá yếu (ít nhất 6 ký tự)";
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_add_alt_1, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create a new account to continue",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Họ và tên
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    labelStyle: TextStyle(color: Colors.black87),
                    hintText: 'Nhập họ và tên',
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.black87),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Vui lòng nhập họ và tên" : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black87),
                    hintText: 'Nhập email',
                    hintStyle: TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.black87),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Vui lòng nhập email";
                    if (!value.contains("@")) return "Email không hợp lệ";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mật khẩu
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: const TextStyle(color: Colors.black87),
                    hintText: 'Nhập mật khẩu',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () =>
                          setState(() => isPasswordVisible = !isPasswordVisible),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Mật khẩu ít nhất 6 ký tự";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nhập lại mật khẩu
                TextFormField(
                  controller: confirmController,
                  obscureText: !isConfirmPasswordVisible,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    labelStyle: const TextStyle(color: Colors.black87),
                    hintText: 'Nhập lại mật khẩu',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () => setState(() =>
                          isConfirmPasswordVisible = !isConfirmPasswordVisible),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Mật khẩu nhập lại không khớp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Nút đăng ký
                ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: Colors.cyan,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 24),

                // Or
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Login
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // TODO: loginWithGoogle()
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Chuyển sang Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
