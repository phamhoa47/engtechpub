import 'package:flutter/material.dart';

class SettingItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }
}
