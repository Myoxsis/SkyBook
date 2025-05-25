import '../models/aircraft.dart';

/// List of common aircraft grouped by manufacturer.
const List<Aircraft> aircrafts = [
  // Airbus
  Aircraft(manufacturer: 'Airbus', model: 'A320'),
  Aircraft(manufacturer: 'Airbus', model: 'A321'),
  Aircraft(manufacturer: 'Airbus', model: 'A330'),
  Aircraft(manufacturer: 'Airbus', model: 'A350'),

  // Boeing
  Aircraft(manufacturer: 'Boeing', model: '737'),
  Aircraft(manufacturer: 'Boeing', model: '747'),
  Aircraft(manufacturer: 'Boeing', model: '757'),
  Aircraft(manufacturer: 'Boeing', model: '767'),
  Aircraft(manufacturer: 'Boeing', model: '777'),
  Aircraft(manufacturer: 'Boeing', model: '787'),

  // Embraer
  Aircraft(manufacturer: 'Embraer', model: 'E170'),
  Aircraft(manufacturer: 'Embraer', model: 'E190'),
  Aircraft(manufacturer: 'Embraer', model: 'E195'),

  // Private jets
  Aircraft(manufacturer: 'Gulfstream', model: 'G650'),
  Aircraft(manufacturer: 'Cessna', model: 'Citation X'),
  Aircraft(manufacturer: 'Bombardier', model: 'Global 7500'),
];

final Map<String, Aircraft> aircraftByDisplay = {
  for (final a in aircrafts) a.display: a,
};
