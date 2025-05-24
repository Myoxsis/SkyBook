import 'package:shared_preferences/shared_preferences.dart';

class AchievementStorage {
  static const String _key = 'unlockedAchievements';

  static Future<Set<String>> loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);
    return list?.toSet() ?? <String>{};
  }

  static Future<void> saveUnlocked(Set<String> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, achievements.toList());
  }
}
