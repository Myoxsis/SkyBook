import '../models/aircraft.dart';

const List<Aircraft> aircrafts = [
  Aircraft(manufacturer: 'Airbus', model: 'A320'),
  Aircraft(manufacturer: 'Airbus', model: 'A321'),
  Aircraft(manufacturer: 'Airbus', model: 'A330'),
  Aircraft(manufacturer: 'Airbus', model: 'A350'),
  Aircraft(manufacturer: 'Boeing', model: '737'),
  Aircraft(manufacturer: 'Boeing', model: '747'),
  Aircraft(manufacturer: 'Boeing', model: '757'),
  Aircraft(manufacturer: 'Boeing', model: '767'),
  Aircraft(manufacturer: 'Boeing', model: '777'),
  Aircraft(manufacturer: 'Boeing', model: '787'),
];

final Map<String, Aircraft> aircraftByDisplay = {
  for (final a in aircrafts) a.display: a,
};
