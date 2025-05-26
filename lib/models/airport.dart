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

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'country': country,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Airport.fromMap(Map<String, dynamic> map) {
    return Airport(
      code: map['code'] as String,
      name: map['name'] as String,
      country: map['country'] as String,
      region: map['region'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}
