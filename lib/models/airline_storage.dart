import 'package:sqflite/sqflite.dart';

import 'airline.dart';
import 'app_database.dart';

class AirlineStorage {
  static Future<List<Airline>> loadAirlines() async {
    final db = await AppDatabase.open();
    final maps = await db.query('airlines');
    return maps.map((e) => Airline.fromMap(e)).toList();
  }
}
