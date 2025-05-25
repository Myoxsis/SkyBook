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
    final stored = prefs.getString(_key);
    final Map<String, dynamic> decoded =
        stored != null ? json.decode(stored) as Map<String, dynamic> : {};
    decoded[id] = time.toIso8601String();
    final encoded = json.encode(decoded);
    await prefs.setString(_key, encoded);
  }
}
