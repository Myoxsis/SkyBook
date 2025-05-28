import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/airport_data.dart';
import '../data/airline_data.dart';
import '../data/aircraft_data.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> open() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'skybook.db');
    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seed(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTables(db);
          await _seed(db);
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE flights ADD COLUMN originRating INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE flights ADD COLUMN destinationRating INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE flights ADD COLUMN seatRating INTEGER DEFAULT 0');
        }
      },
    );
    return _db!;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS flights(
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
  isBusiness INTEGER,
  originRating INTEGER,
  destinationRating INTEGER,
  seatRating INTEGER
)''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS airports(
  code TEXT PRIMARY KEY,
  name TEXT,
  country TEXT,
  region TEXT,
  latitude REAL,
  longitude REAL
)''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS airlines(
  name TEXT PRIMARY KEY,
  callsign TEXT,
  code TEXT
)''');
    await db.execute('''
CREATE TABLE IF NOT EXISTS aircrafts(
  id TEXT PRIMARY KEY,
  manufacturer TEXT,
  model TEXT,
  fuelBurnPerKm REAL,
  classConfig TEXT
)''');
  }

  static Future<void> _seed(Database db) async {
    for (final a in seedAirports) {
      await db.insert('airports', a.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (final a in seedAirlines) {
      await db.insert('airlines', a.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    for (final a in seedAircrafts) {
      await db.insert('aircrafts', a.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }
}
