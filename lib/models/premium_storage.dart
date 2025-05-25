import 'package:shared_preferences/shared_preferences.dart';

class PremiumStorage {
  static const String _key = 'premiumStatus';

  static Future<bool> loadPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> savePremium(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, enabled);
  }
}
