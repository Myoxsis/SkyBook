class Airport {
  final String code;
  final String name;
  final String country;
  final String region;
  final double latitude;
  final double longitude;

  const Airport({
    required this.code,
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
  });

  String get display => '$code - $name';
}
