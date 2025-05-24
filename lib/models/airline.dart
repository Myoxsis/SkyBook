class Airline {
  final String name;
  final String callsign;
  final String code;

  const Airline({required this.name, required this.callsign, required this.code});

  String get display => name;
}
