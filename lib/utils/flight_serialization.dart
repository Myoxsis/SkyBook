import 'dart:convert';

import '../models/flight.dart';

/// Helper methods to convert flights to and from CSV or JSON.
class FlightSerialization {
  static const List<String> _headers = [
    'id',
    'date',
    'aircraft',
    'manufacturer',
    'airline',
    'callsign',
    'duration',
    'notes',
    'origin',
    'destination',
    'travelClass',
    'seatNumber',
    'seatLocation',
    'distanceKm',
    'carbonKg',
    'isFavorite',
    'isBusiness'
  ];

  /// Returns a JSON string representing [flights].
  static String toJson(List<Flight> flights) {
    final list = flights.map((f) => f.toMap()).toList();
    return jsonEncode(list);
  }

  /// Parses flights from JSON [data].
  static List<Flight> fromJson(String data) {
    final decoded = jsonDecode(data);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => Flight.fromMap(e))
        .toList();
  }

  /// Returns a CSV string representing [flights].
  static String toCsv(List<Flight> flights) {
    final buffer = StringBuffer();
    buffer.writeln(_headers.join(','));
    for (final f in flights) {
      final row = [
        f.id,
        f.date,
        f.aircraft,
        f.manufacturer,
        f.airline,
        f.callsign,
        f.duration,
        f.notes.replaceAll('\n', ' '),
        f.origin,
        f.destination,
        f.travelClass,
        f.seatNumber,
        f.seatLocation,
        f.distanceKm.toString(),
        f.carbonKg.toString(),
        f.isFavorite.toString(),
        f.isBusiness.toString()
      ];
      buffer.writeln(row.join(','));
    }
    return buffer.toString();
  }

  /// Parses flights from CSV [data].
  static List<Flight> fromCsv(String data) {
    final lines = data.trim().split(RegExp(r'\r?\n'));
    if (lines.isEmpty) return [];
    final flights = <Flight>[];
    for (var i = 1; i < lines.length; i++) {
      final parts = lines[i].split(',');
      if (parts.length < _headers.length) continue;
      final map = <String, dynamic>{};
      for (var j = 0; j < _headers.length; j++) {
        map[_headers[j]] = _parse(parts[j]);
      }
      flights.add(Flight.fromMap(map));
    }
    return flights;
  }

  static dynamic _parse(String value) {
    if (value == 'true') return true;
    if (value == 'false') return false;
    final num? number = num.tryParse(value);
    if (number != null) return number;
    return value;
  }
}
