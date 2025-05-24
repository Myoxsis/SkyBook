import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const String _key = 'darkMode';

  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> saveDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, darkMode);
  }
}
