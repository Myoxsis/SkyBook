class Aircraft {
  final String manufacturer;
  final String model;

  const Aircraft({required this.manufacturer, required this.model});

  String get display => '$manufacturer $model';
}
