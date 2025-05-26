class Flight {
  final String id;
  final String date;
  final String aircraft;
  final String manufacturer;
  final String airline;
  final String callsign;
  final String duration;
  final String notes;
  final String origin;
  final String destination;
  final String travelClass;
  final String seatNumber;
  final String seatLocation;
  final double distanceKm;
  final double carbonKg;
  final bool isFavorite;
  final bool isBusiness;

  Flight({
    required this.id,
    required this.date,
    required this.aircraft,
    required this.manufacturer,
    this.airline = '',
    this.callsign = '',
    required this.duration,
    required this.notes,
    required this.origin,
    required this.destination,
    required this.travelClass,
    required this.seatNumber,
    required this.seatLocation,
    this.distanceKm = 0,
    this.carbonKg = 0,
    this.isFavorite = false,
    this.isBusiness = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'aircraft': aircraft,
      'manufacturer': manufacturer,
      'airline': airline,
      'callsign': callsign,
      'duration': duration,
      'notes': notes,
      'origin': origin,
      'destination': destination,
      'travelClass': travelClass,
      'seatNumber': seatNumber,
      'seatLocation': seatLocation,
      'distanceKm': distanceKm,
      'carbonKg': carbonKg,
      // Sqflite does not support boolean values directly. Store booleans as
      // integers for compatibility.
      'isFavorite': isFavorite ? 1 : 0,
      'isBusiness': isBusiness ? 1 : 0,
    };
  }

  Flight copyWith({
    String? id,
    String? date,
    String? aircraft,
    String? manufacturer,
    String? airline,
    String? callsign,
    String? duration,
    String? notes,
    String? origin,
    String? destination,
    String? travelClass,
    String? seatNumber,
    String? seatLocation,
    double? distanceKm,
    double? carbonKg,
    bool? isFavorite,
    bool? isBusiness,
  }) {
    return Flight(
      id: id ?? this.id,
      date: date ?? this.date,
      aircraft: aircraft ?? this.aircraft,
      manufacturer: manufacturer ?? this.manufacturer,
      airline: airline ?? this.airline,
      callsign: callsign ?? this.callsign,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      travelClass: travelClass ?? this.travelClass,
      seatNumber: seatNumber ?? this.seatNumber,
      seatLocation: seatLocation ?? this.seatLocation,
      distanceKm: distanceKm ?? this.distanceKm,
      carbonKg: carbonKg ?? this.carbonKg,
      isFavorite: isFavorite ?? this.isFavorite,
      isBusiness: isBusiness ?? this.isBusiness,
    );
  }

  factory Flight.fromMap(Map<String, dynamic> map) {
    return Flight(
      id: map['id'] as String,
      date: map['date'] as String,
      aircraft: map['aircraft'] as String,
      manufacturer: map['manufacturer'] as String? ?? _manufacturerFromAircraft(map['aircraft'] as String),
      airline: map['airline'] as String? ?? '',
      callsign: map['callsign'] as String? ?? '',
      duration: map['duration'] as String,
      notes: map['notes'] as String? ?? '',
      origin: map['origin'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      travelClass: map['travelClass'] as String? ?? '',
      seatNumber: map['seatNumber'] as String? ?? '',
      seatLocation: map['seatLocation'] as String? ?? '',
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0,
      carbonKg: (map['carbonKg'] as num?)?.toDouble() ?? 0,
      isFavorite: _parseBool(map['isFavorite']),
      isBusiness: _parseBool(map['isBusiness']),
    );
  }

  /// Converts various representations to a boolean.
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static String _manufacturerFromAircraft(String aircraft) {
    if (aircraft.startsWith('Airbus')) return 'Airbus';
    if (aircraft.startsWith('Boeing')) return 'Boeing';
    return '';
  }
}
