class Airline {
  final String name;
  final String callsign;

  const Airline({required this.name, required this.callsign});

  String get display => name;
}
