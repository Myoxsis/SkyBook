import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementStorage {
  static const String _key = 'achievements';

  static Future<Map<String, DateTime>> loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return {};
    final Map<String, dynamic> decoded = json.decode(stored);
    final result = <String, DateTime>{};
    for (final entry in decoded.entries) {
      final time = DateTime.tryParse(entry.value as String? ?? '');
      if (time != null) result[entry.key] = time;
    }
    return result;
  }

  static Future<void> saveUnlocked(String id, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await loadUnlocked();
    current[id] = time;
    final encoded = json.encode(
        current.map((key, value) => MapEntry(key, value.toIso8601String())));
    await prefs.setString(_key, encoded);
  }
}
