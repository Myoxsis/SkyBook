import 'package:shared_preferences/shared_preferences.dart';

class DeveloperStorage {
  static const String _key = 'developerMode';

  static Future<bool> loadDeveloperMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> saveDeveloperMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, enabled);
  }
}
