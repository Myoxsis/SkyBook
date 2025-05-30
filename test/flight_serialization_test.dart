import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/utils/flight_serialization.dart';
import 'package:skybook/models/flight.dart';

Flight _flight() {
  return Flight(
    id: '1',
    date: '2023-01-01',
    aircraft: 'A320',
    manufacturer: 'Airbus',
    airline: 'TestAir',
    callsign: 'TA123',
    duration: '2',
    notes: '',
    origin: 'JFK',
    destination: 'LAX',
    travelClass: 'Economy',
    seatNumber: '12A',
    seatLocation: 'Window',
    distanceKm: 1000,
    carbonKg: 100,
    isFavorite: false,
    isBusiness: false,
    originRating: 3,
    destinationRating: 4,
    seatRating: 5,
  );
}

void main() {
  test('JSON round trip preserves ratings', () {
    final flights = [_flight()];
    final json = FlightSerialization.toJson(flights);
    final parsed = FlightSerialization.fromJson(json);
    expect(parsed.first.originRating, 3);
    expect(parsed.first.destinationRating, 4);
    expect(parsed.first.seatRating, 5);
  });

  test('CSV round trip preserves ratings', () {
    final flights = [_flight()];
    final csv = FlightSerialization.toCsv(flights);
    final parsed = FlightSerialization.fromCsv(csv);
    expect(parsed.first.originRating, 3);
    expect(parsed.first.destinationRating, 4);
    expect(parsed.first.seatRating, 5);
  });
}
