class Flight {
  final String id;
  final String date;
  final String aircraft;
  final String duration;
  final String notes;

  Flight({
    required this.id,
    required this.date,
    required this.aircraft,
    required this.duration,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'aircraft': aircraft,
      'duration': duration,
      'notes': notes,
    };
  }

  factory Flight.fromMap(Map<String, dynamic> map) {
    return Flight(
      id: map['id'] as String,
      date: map['date'] as String,
      aircraft: map['aircraft'] as String,
      duration: map['duration'] as String,
      notes: map['notes'] as String? ?? '',
    );
  }
}
