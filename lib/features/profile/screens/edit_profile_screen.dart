import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool showPasswordFields = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _updateDisplayName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    setState(() => isLoading = true);

    try {
      await user?.updateDisplayName(newName);
      await user?.reload();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đã cập nhật tên')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      _showMessage('Lỗi: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    final currentPass = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ mật khẩu");
      return;
    }

    if (newPass != confirmPass) {
      _showMessage("Mật khẩu xác nhận không khớp");
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPass,
      );
      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPass);
      await user!.reload();

      _showMessage("✅ Đổi mật khẩu thành công");

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() => showPasswordFields = false);
    } on FirebaseAuthException catch (e) {
      _showMessage("❌ ${e.message}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Chỉnh sửa hồ sơ", style: TextStyle(color: colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Họ tên", style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: textStyle,
              decoration: InputDecoration(
                hintText: "Gì cũng được...",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateDisplayName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Lưu", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Đổi mật khẩu",
                style: titleStyle?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                showPasswordFields ? Icons.expand_less : Icons.expand_more,
                color: colorScheme.onSurface,
              ),
              onTap: () => setState(() => showPasswordFields = !showPasswordFields),
            ),
            if (showPasswordFields) ...[
              const SizedBox(height: 10),
              _buildPasswordField("Mật khẩu hiện tại", _currentPasswordController),
              const SizedBox(height: 12),
              _buildPasswordField("Mật khẩu mới", _newPasswordController),
              const SizedBox(height: 12),
              _buildPasswordField("Xác nhận mật khẩu", _confirmPasswordController),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Đổi mật khẩu", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
