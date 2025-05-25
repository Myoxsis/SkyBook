import 'dart:math' as math;

import '../data/aircraft_data.dart';

/// CO₂ produced per kilogram of jet fuel burned.
const double co2PerKgFuel = 3.16;

/// Adjustment multipliers based on travel class.
const Map<String, double> classFactors = {
  'Economy': 1.0,
  'Premium': 1.2,
  'Business': 1.5,
  'First': 2.0,
};

/// Estimates the carbon emissions in kilograms for a flight.
///
/// [distanceKm] is the flight distance in kilometers, [aircraft] is the
/// aircraft model, and [travelClass] is the passenger class such as
/// Economy or Business. If the aircraft or class is not found, a generic
/// estimate is used.
double estimateEmissions(
    double distanceKm, String aircraft, String travelClass) {
  final info = aircraftByDisplay[aircraft];
  if (info == null) {
    // Fallback generic factor per km when aircraft data is missing.
    const genericFactor = 0.09; // kg CO₂ per km per passenger
    final classFactor = classFactors[travelClass] ?? 1.0;
    return distanceKm * genericFactor * classFactor;
  }

  final totalFuel = info.fuelBurnPerKm * distanceKm; // kg fuel
  final totalCo2 = totalFuel * co2PerKgFuel;
  final seatCount =
      info.classConfig.values.fold<int>(0, (a, b) => a + b); // total seats
  final basePerSeat = totalCo2 / math.max(1, seatCount);
  final classFactor = classFactors[travelClass] ?? 1.0;
  return basePerSeat * classFactor;
}
