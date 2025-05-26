import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'flight.dart';

class FlightStorage {
  static Database? _db;

  static Future<Database> _openDb() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'skybook.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE flights(
  id TEXT PRIMARY KEY,
  date TEXT,
  aircraft TEXT,
  manufacturer TEXT,
  airline TEXT,
  callsign TEXT,
  duration TEXT,
  notes TEXT,
  origin TEXT,
  destination TEXT,
  travelClass TEXT,
  seatNumber TEXT,
  seatLocation TEXT,
  distanceKm REAL,
  carbonKg REAL,
  isFavorite INTEGER,
  isBusiness INTEGER
)''');
      },
    );
    return _db!;
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
