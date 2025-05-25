import 'dart:math' as math;

/// Default emission factors in kilograms CO₂ per kilometer for some aircraft.
/// These are simplified values for demonstration purposes.
const Map<String, double> aircraftFactors = {
  'Airbus A320': 0.09,
  'Airbus A321': 0.09,
  'Boeing 737': 0.09,
  'Boeing 777': 0.11,
  'Boeing 787': 0.10,
};

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
/// Economy or Business. If the aircraft or class is not found in the maps,
/// default factors are used.
double estimateEmissions(
    double distanceKm, String aircraft, String travelClass) {
  final aircraftFactor =
      aircraftFactors[aircraft] ?? aircraftFactors.values.first;
  final classFactor = classFactors[travelClass] ?? 1.0;
  return distanceKm * aircraftFactor * classFactor;
}
