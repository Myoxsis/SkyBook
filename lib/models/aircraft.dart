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
}
