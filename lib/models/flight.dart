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
  final bool isFavorite;

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
    this.isFavorite = false,
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
      'isFavorite': isFavorite,
    };
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
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  static String _manufacturerFromAircraft(String aircraft) {
    if (aircraft.startsWith('Airbus')) return 'Airbus';
    if (aircraft.startsWith('Boeing')) return 'Boeing';
    return '';
  }
}
