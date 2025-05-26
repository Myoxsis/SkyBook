import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

import 'flight.dart';

class FlightStorage {
  static Future<Database> _openDb() async {
    return AppDatabase.open();
  }

  static Future<List<Flight>> loadFlights() async {
    final db = await _openDb();
    final maps = await db.query('flights');
    return maps.map((e) => Flight.fromMap(e)).toList();
  }

  static Future<void> saveFlights(List<Flight> flights) async {
    final db = await _openDb();
    await db.transaction((txn) async {
      await txn.delete('flights');
      for (final flight in flights) {
        await txn.insert('flights', flight.toMap());
      }
    });
  }
}
