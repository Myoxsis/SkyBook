import 'package:latlong2/latlong.dart';

import '../data/airport_data.dart';
import '../models/flight.dart';
import '../models/achievement.dart';

Achievement _progress(
  String id,
  String title,
  String description,
  String category,
  int current,
  int target,
  {DateTime? unlockedAt}) {
  return Achievement(
    id: id,
    title: title,
    description: description,
    category: category,
    target: target,
    progress: current.clamp(0, target),
    achieved: current >= target,
    unlockedAt: unlockedAt,
  );
}

List<Achievement> calculateAchievements(List<Flight> flights,
    [Map<String, DateTime> unlocked = const {}]) {
  final distance = const Distance();
  final totalFlights = flights.length;

  double totalKm = 0;
  final airportsVisited = <String>{};
  final countriesVisited = <String>{};

  for (final f in flights) {
    final origin = airportByCode[f.origin];
    final dest = airportByCode[f.destination];
    if (origin != null) {
      airportsVisited.add(origin.code);
      countriesVisited.add(origin.country);
    }
    if (dest != null) {
      airportsVisited.add(dest.code);
      countriesVisited.add(dest.country);
    }
    if (origin != null && dest != null) {
      final start = LatLng(origin.latitude, origin.longitude);
      final end = LatLng(dest.latitude, dest.longitude);
      totalKm += distance.as(LengthUnit.Kilometer, start, end);
    }
  }

  return [
    _progress('firstFlight', 'First Flight', 'Log 1 flight', 'Flights',
        totalFlights, 1,
        unlockedAt: unlocked['firstFlight']),
    _progress('frequentFlyer', 'Frequent Flyer', 'Log 50 flights', 'Flights',
        totalFlights, 50,
        unlockedAt: unlocked['frequentFlyer']),
    _progress('globeTrotter', 'Globe Trotter', 'Log 100 flights', 'Flights',
        totalFlights, 100,
        unlockedAt: unlocked['globeTrotter']),
    _progress('shortHaul', 'Short Haul Hero', 'Travel 1,000 km', 'Distance',
        totalKm.round(), 1000,
        unlockedAt: unlocked['shortHaul']),
    _progress('aroundWorld', 'Around the World', 'Travel 40,075 km', 'Distance',
        totalKm.round(), 40075,
        unlockedAt: unlocked['aroundWorld']),
    _progress('longHaul', 'Long Haul Legend', 'Travel 100,000 km', 'Distance',
        totalKm.round(), 100000,
        unlockedAt: unlocked['longHaul']),
    _progress('newHorizons', 'New Horizons', 'Visit 5 different countries',
        'Destinations', countriesVisited.length, 5,
        unlockedAt: unlocked['newHorizons']),
    _progress('airportAddict', 'Airport Addict', 'Land at 50 different airports',
        'Destinations', airportsVisited.length, 50,
        unlockedAt: unlocked['airportAddict']),
  ];
}
