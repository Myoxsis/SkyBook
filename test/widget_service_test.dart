import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/services/widget_service.dart';
import 'package:skybook/models/flight.dart';

Flight _flight(double distance, double carbon) {
  return Flight(
    id: '1',
    date: '2023-01-01',
    aircraft: 'Boeing 737',
    manufacturer: 'Boeing',
    airline: '',
    callsign: '',
    duration: '',
    notes: '',
    origin: '',
    destination: '',
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
      _flight(1000, 50),
      _flight(2000, 75),
    ];

    final totals = WidgetService.aggregate(flights);

    expect(totals.flights, 2);
    expect(totals.distanceKm, 3000);
    expect(totals.carbonKg, 125);
  });
}
