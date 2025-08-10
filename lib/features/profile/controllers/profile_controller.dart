import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileController extends ChangeNotifier {
  UserProfile _user = UserProfile(
    name: "Người dùng",
    email: "user@example.com",
    avatarUrl: "assets/images/avatar.png",
  );

  bool _darkMode = false;
  bool _sound = true;

  UserProfile get user => _user;
  bool get darkMode => _darkMode;
  bool get sound => _sound;

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _sound = value;
    notifyListeners();
  }

  void updateProfile(String name, String avatarUrl) {
    _user = UserProfile(
      name: name,
      email: _user.email,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }
}
