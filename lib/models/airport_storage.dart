import 'package:sqflite/sqflite.dart';

import 'airport.dart';
import 'app_database.dart';

class AirportStorage {
  static Future<List<Airport>> loadAirports() async {
    final db = await AppDatabase.open();
    final maps = await db.query('airports');
    return maps.map((e) => Airport.fromMap(e)).toList();
  }
}
