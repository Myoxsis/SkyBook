import 'package:sqflite/sqflite.dart';

import 'aircraft.dart';
import 'app_database.dart';

class AircraftStorage {
  static Future<List<Aircraft>> loadAircrafts() async {
    final db = await AppDatabase.open();
    final maps = await db.query('aircrafts');
    return maps.map((e) => Aircraft.fromMap(e)).toList();
  }
}
