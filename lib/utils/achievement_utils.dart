import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import '../data/airport_data.dart';
import '../models/flight.dart';
import '../models/achievement.dart';

Achievement _progress(
  String id,
  String title,
  String description,
  String category,
  IconData icon,
  String asset,
  int current,
  int target,
  {int tier = 1, DateTime? unlockedAt}) {
  return Achievement(
    id: id,
    title: title,
    description: description,
    category: category,
    icon: icon,
    assetPath: asset,
    target: target,
    progress: current.clamp(0, target),
    achieved: current >= target,
    unlockedAt: unlockedAt,
    tier: tier,
  );
}

List<Achievement> calculateAchievements(List<Flight> flights,
    [Map<String, DateTime> unlocked = const {}]) {
  final totalFlights = flights.length;
  final distance = const Distance();
  double totalKm = 0;
  final airportsVisited = <String>{};
  final countriesVisited = <String>{};
  final classesFlown = <String>{};
  double totalCarbon = 0;

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
    if (f.travelClass.isNotEmpty) {
      classesFlown.add(f.travelClass);
    }
    final carbon = f.carbonKg.isNaN ? 0 : f.carbonKg;
    totalCarbon += carbon;

    if (f.distanceKm > 0) {
      totalKm += f.distanceKm;
    } else if (origin != null && dest != null) {
      final start = LatLng(origin.latitude, origin.longitude);
      final end = LatLng(dest.latitude, dest.longitude);
      totalKm += distance.as(LengthUnit.Kilometer, start, end);
    }
  }

  return [
    _progress(
      'firstFlight',
      'First Flight',
      'Log 1 flight',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      1,
      unlockedAt: unlocked['firstFlight'],
      tier: 1,
    ),
    _progress(
      'frequentFlyer10',
      'Frequent Flyer 10',
      'Log 10 flights',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      10,
      tier: 1,
      unlockedAt: unlocked['frequentFlyer10'],
    ),
    _progress(
      'frequentFlyer25',
      'Frequent Flyer 25',
      'Log 25 flights',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      25,
      tier: 2,
      unlockedAt: unlocked['frequentFlyer25'],
    ),
    _progress(
      'frequentFlyer50',
      'Frequent Flyer 50',
      'Log 50 flights',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      50,
      tier: 3,
      unlockedAt: unlocked['frequentFlyer50'],
    ),
    _progress(
      'globeTrotter',
      'Globe Trotter',
      'Log 100 flights',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      100,
      tier: 4,
      unlockedAt: unlocked['globeTrotter'],
    ),
    _progress(
      'frequentFlyer200',
      'Frequent Flyer 200',
      'Log 200 flights',
      'Flights',
      Icons.flight,
      'assets/badges/plane.png',
      totalFlights,
      200,
      tier: 5,
      unlockedAt: unlocked['frequentFlyer200'],
    ),
    _progress(
      'classExplorer',
      'Class Explorer',
      'Fly in Economy, Premium, Business and First',
      'Flights',
      Icons.chair,
      'assets/badges/plane.png',
      classesFlown.intersection({'Economy', 'Premium', 'Business', 'First'}).length,
      4,
      unlockedAt: unlocked['classExplorer'],
    ),
    Achievement(
      id: 'ecoAware',
      title: 'Eco Aware',
      description: 'Fly 20 flights with under 1t CO₂',
      category: 'Flights',
      icon: Icons.cloud,
      assetPath: 'assets/badges/plane.png',
      target: 20,
      progress: totalFlights.clamp(0, 20),
      achieved: totalFlights >= 20 && totalCarbon <= 1000,
      unlockedAt: unlocked['ecoAware'],
    ),
    _progress(
      'shortHaul',
      'Short Haul Hero',
      'Travel 1,000 km',
      'Distance',
      Icons.flight_takeoff,
      'assets/badges/globe.png',
      totalKm.round(),
      1000,
      tier: 1,
      unlockedAt: unlocked['shortHaul'],
    ),
    _progress(
      'aroundWorld',
      'Around the World',
      'Travel 40,075 km',
      'Distance',
      Icons.flight_takeoff,
      'assets/badges/globe.png',
      totalKm.round(),
      40075,
      tier: 2,
      unlockedAt: unlocked['aroundWorld'],
    ),
    _progress(
      'longHaul',
      'Long Haul Legend',
      'Travel 100,000 km',
      'Distance',
      Icons.flight_takeoff,
      'assets/badges/globe.png',
      totalKm.round(),
      100000,
      tier: 3,
      unlockedAt: unlocked['longHaul'],
    ),
    _progress(
      'jetSetter',
      'Jet Setter',
      'Travel 250,000 km',
      'Distance',
      Icons.flight_takeoff,
      'assets/badges/globe.png',
      totalKm.round(),
      250000,
      tier: 4,
      unlockedAt: unlocked['jetSetter'],
    ),
    _progress(
      'skyLegend',
      'Sky Legend',
      'Travel 500,000 km',
      'Distance',
      Icons.flight_takeoff,
      'assets/badges/globe.png',
      totalKm.round(),
      500000,
      tier: 5,
      unlockedAt: unlocked['skyLegend'],
    ),
    _progress(
      'newHorizons',
      'New Horizons',
      'Visit 5 different countries',
      'Destinations',
      Icons.public,
      'assets/badges/trophy.png',
      countriesVisited.length,
      5,
      tier: 1,
      unlockedAt: unlocked['newHorizons'],
    ),
    _progress(
      'worldExplorer',
      'World Explorer',
      'Visit 20 different countries',
      'Destinations',
      Icons.public,
      'assets/badges/trophy.png',
      countriesVisited.length,
      20,
      tier: 2,
      unlockedAt: unlocked['worldExplorer'],
    ),
    _progress(
      'airportAddict',
      'Airport Addict',
      'Land at 50 different airports',
      'Destinations',
      Icons.local_airport,
      'assets/badges/trophy.png',
      airportsVisited.length,
      50,
      tier: 1,
      unlockedAt: unlocked['airportAddict'],
    ),
    _progress(
      'airportMaster',
      'Airport Master',
      'Land at 100 different airports',
      'Destinations',
      Icons.local_airport,
      'assets/badges/trophy.png',
      airportsVisited.length,
      100,
      tier: 2,
      unlockedAt: unlocked['airportMaster'],
    ),
    _progress(
      'airportConqueror',
      'Airport Conqueror',
      'Land at 200 different airports',
      'Destinations',
      Icons.local_airport,
      'assets/badges/trophy.png',
      airportsVisited.length,
      200,
      tier: 3,
      unlockedAt: unlocked['airportConqueror'],
    ),
  ];
}
