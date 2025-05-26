class Airline {
  final String name;
  final String callsign;
  final String code;

  const Airline({required this.name, required this.callsign, required this.code});

  String get display => name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'callsign': callsign,
      'code': code,
    };
  }

  factory Airline.fromMap(Map<String, dynamic> map) {
    return Airline(
      name: map['name'] as String,
      callsign: map['callsign'] as String,
      code: map['code'] as String,
    );
  }
}
