import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/services/widget_service.dart';
import 'package:skybook/models/flight.dart';

Flight _flight({
  required String aircraft,
  required String airline,
  required String destination,
  required String duration,
  double distance = 0,
  double carbon = 0,
}) {
  return Flight(
    id: '1',
    date: '2023-01-01',
    aircraft: aircraft,
    manufacturer: '',
    airline: airline,
    callsign: '',
    duration: duration,
    notes: '',
    origin: '',
    destination: destination,
    travelClass: '',
    seatNumber: '',
    seatLocation: '',
    distanceKm: distance,
    carbonKg: carbon,
    originRating: 0,
    destinationRating: 0,
    seatRating: 0,
  );
}

void main() {
  test('aggregate totals sums distance and carbon', () {
    final flights = [
      _flight(
        aircraft: 'Boeing 737',
        airline: 'Delta',
        destination: 'JFK',
        duration: '1',
        distance: 1000,
        carbon: 50,
      ),
      _flight(
        aircraft: 'Airbus A320',
        airline: 'Delta',
        destination: 'LAX',
        duration: '2',
        distance: 2000,
        carbon: 75,
      ),
    ];

    final totals = WidgetService.aggregate(flights);

    expect(totals.flights, 2);
    expect(totals.distanceKm, 3000);
    expect(totals.carbonKg, 125);
  });

  test('aggregateStatus returns favorite metrics', () {
    final flights = [
      _flight(
        aircraft: 'Boeing 737',
        airline: 'Delta',
        destination: 'LAX',
        duration: '2',
        distance: 1000,
        carbon: 10,
      ),
      _flight(
        aircraft: 'Airbus A320',
        airline: 'United',
        destination: 'JFK',
        duration: '3',
        distance: 2000,
        carbon: 20,
      ),
      _flight(
        aircraft: 'Boeing 737',
        airline: 'Delta',
        destination: 'LAX',
        duration: '1',
        distance: 500,
        carbon: 15,
      ),
    ];

    final totals = WidgetService.aggregateStatus(flights);

    expect(totals.flights, 3);
    expect(totals.durationHours, closeTo(6, 0.001));
    expect(totals.carbonKg, 45);
    expect(totals.favoritePlane, 'Boeing 737');
    expect(totals.favoriteAirline, 'Delta');
    expect(totals.favoriteDestination, 'LAX');
  });
}
