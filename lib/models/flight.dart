class Flight {
  final String id;
  final String date;
  final String aircraft;
  final String manufacturer;
  final String duration;
  final String notes;
  final String origin;
  final String destination;
  final bool isFavorite;

  Flight({
    required this.id,
    required this.date,
    required this.aircraft,
    required this.manufacturer,
    required this.duration,
    required this.notes,
    required this.origin,
    required this.destination,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'aircraft': aircraft,
      'manufacturer': manufacturer,
      'duration': duration,
      'notes': notes,
      'origin': origin,
      'destination': destination,
      'isFavorite': isFavorite,
    };
  }

  factory Flight.fromMap(Map<String, dynamic> map) {
    return Flight(
      id: map['id'] as String,
      date: map['date'] as String,
      aircraft: map['aircraft'] as String,
      manufacturer: map['manufacturer'] as String? ?? _manufacturerFromAircraft(map['aircraft'] as String),
      duration: map['duration'] as String,
      notes: map['notes'] as String? ?? '',
      origin: map['origin'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  static String _manufacturerFromAircraft(String aircraft) {
    if (aircraft.startsWith('Airbus')) return 'Airbus';
    if (aircraft.startsWith('Boeing')) return 'Boeing';
    return '';
  }
}
