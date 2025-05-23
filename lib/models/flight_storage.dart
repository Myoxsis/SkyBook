import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'flight.dart';

class FlightStorage {
  static Future<List<Flight>> loadFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('flights');
    if (stored != null) {
      final List<dynamic> decoded = json.decode(stored);
      return decoded.map((e) => Flight.fromMap(e)).toList();
    }
    return [];
  }

  static Future<void> saveFlights(List<Flight> flights) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(flights.map((f) => f.toMap()).toList());
    await prefs.setString('flights', encoded);
  }
}
