import '../models/aircraft.dart';

/// List of common aircraft grouped by manufacturer.
const List<Aircraft> aircrafts = [
  // Airbus
  Aircraft(
    manufacturer: 'Airbus',
    model: 'A320',
    fuelBurnPerKm: 3.0,
    classConfig: const {'Economy': 150, 'Business': 12},
  ),
  Aircraft(
    manufacturer: 'Airbus',
    model: 'A321',
    fuelBurnPerKm: 3.2,
    classConfig: const {'Economy': 170, 'Business': 16},
  ),
  Aircraft(
    manufacturer: 'Airbus',
    model: 'A330',
    fuelBurnPerKm: 6.2,
    classConfig: const {'Economy': 250, 'Business': 40, 'First': 8},
  ),
  Aircraft(
    manufacturer: 'Airbus',
    model: 'A350',
    fuelBurnPerKm: 5.8,
    classConfig: const {'Economy': 280, 'Business': 40, 'First': 10},
  ),

  // Boeing
  Aircraft(
    manufacturer: 'Boeing',
    model: '737',
    fuelBurnPerKm: 3.1,
    classConfig: const {'Economy': 150, 'Business': 12},
  ),
  Aircraft(
    manufacturer: 'Boeing',
    model: '747',
    fuelBurnPerKm: 10.0,
    classConfig: const {'Economy': 340, 'Business': 60, 'First': 14},
  ),
  Aircraft(
    manufacturer: 'Boeing',
    model: '757',
    fuelBurnPerKm: 3.5,
    classConfig: const {'Economy': 180, 'Business': 20},
  ),
  Aircraft(
    manufacturer: 'Boeing',
    model: '767',
    fuelBurnPerKm: 4.7,
    classConfig: const {'Economy': 220, 'Business': 24, 'First': 8},
  ),
  Aircraft(
    manufacturer: 'Boeing',
    model: '777',
    fuelBurnPerKm: 6.8,
    classConfig: const {'Economy': 300, 'Business': 50, 'First': 14},
  ),
  Aircraft(
    manufacturer: 'Boeing',
    model: '787',
    fuelBurnPerKm: 5.2,
    classConfig: const {'Economy': 280, 'Business': 40, 'First': 8},
  ),

  // Embraer
  Aircraft(
    manufacturer: 'Embraer',
    model: 'E170',
    fuelBurnPerKm: 1.8,
    classConfig: const {'Economy': 60, 'Business': 6},
  ),
  Aircraft(
    manufacturer: 'Embraer',
    model: 'E190',
    fuelBurnPerKm: 1.9,
    classConfig: const {'Economy': 80, 'Business': 8},
  ),
  Aircraft(
    manufacturer: 'Embraer',
    model: 'E195',
    fuelBurnPerKm: 2.0,
    classConfig: const {'Economy': 100, 'Business': 8},
  ),

  // Private jets
  Aircraft(
    manufacturer: 'Gulfstream',
    model: 'G650',
    fuelBurnPerKm: 2.1,
    classConfig: const {'First': 12},
  ),
  Aircraft(
    manufacturer: 'Cessna',
    model: 'Citation X',
    fuelBurnPerKm: 1.2,
    classConfig: const {'First': 8},
  ),
  Aircraft(
    manufacturer: 'Bombardier',
    model: 'Global 7500',
    fuelBurnPerKm: 2.5,
    classConfig: const {'First': 14},
  ),
];

final Map<String, Aircraft> aircraftByDisplay = {
  for (final a in aircrafts) a.display: a,
};
