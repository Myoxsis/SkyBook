import 'dart:convert';

class Aircraft {
  final String manufacturer;
  final String model;
  final double fuelBurnPerKm;
  final Map<String, int> classConfig;

  const Aircraft({
    required this.manufacturer,
    required this.model,
    required this.fuelBurnPerKm,
    required this.classConfig,
  });

  String get display => '$manufacturer $model';

  Map<String, dynamic> toMap() {
    return {
      'id': display,
      'manufacturer': manufacturer,
      'model': model,
      'fuelBurnPerKm': fuelBurnPerKm,
      'classConfig': json.encode(classConfig),
    };
  }

  factory Aircraft.fromMap(Map<String, dynamic> map) {
    return Aircraft(
      manufacturer: map['manufacturer'] as String,
      model: map['model'] as String,
      fuelBurnPerKm: (map['fuelBurnPerKm'] as num).toDouble(),
      classConfig: Map<String, int>.from(json.decode(map['classConfig'] as String)),
    );
  }
}
