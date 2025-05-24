class Airport {
  final String code;
  final String name;
  final String country;

  const Airport({required this.code, required this.name, required this.country});

  String get display => '$code - $name';
}
