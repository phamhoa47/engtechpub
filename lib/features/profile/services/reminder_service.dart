import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {
  static const _keyHour = 'reminder_hour';
  static const _keyMinute = 'reminder_minute';

  static Future<void> saveReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHour, hour);
    await prefs.setInt(_keyMinute, minute);
  }

  static Future<List<int>?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_keyHour);
    final minute = prefs.getInt(_keyMinute);
    if (hour != null && minute != null) {
      return [hour, minute];
    }
    return null;
  }
}
