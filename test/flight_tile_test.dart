import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/widgets/flight_tile.dart';
import 'package:skybook/models/flight.dart';
import 'package:skybook/models/airport.dart';
import 'package:skybook/data/airport_data.dart';

void main() {
  testWidgets('flight tile displays city names', (tester) async {
    airportByCode = {
      'LAX': const Airport(
        code: 'LAX',
        name: 'Los Angeles International',
        city: 'Los Angeles',
        country: 'USA',
        region: '',
        latitude: 0,
        longitude: 0,
      ),
      'JFK': const Airport(
        code: 'JFK',
        name: 'John F. Kennedy International',
        city: 'New York',
        country: 'USA',
        region: '',
        latitude: 0,
        longitude: 0,
      ),
    };

    final flight = Flight(
      id: '1',
      date: '2023-01-01',
      aircraft: 'Boeing 737',
      manufacturer: 'Boeing',
      airline: '',
      callsign: '',
      duration: '2',
      notes: '',
      origin: 'LAX',
      destination: 'JFK',
      travelClass: '',
      seatNumber: '',
      seatLocation: '',
      distanceKm: 0,
      carbonKg: 0,
      originRating: 0,
      destinationRating: 0,
      seatRating: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlightTile(
            flight: flight,
            onToggleFavorite: () {},
          ),
        ),
      ),
    );

    expect(find.text('LAX'), findsOneWidget);
    expect(find.text('Los Angeles'), findsOneWidget);
    expect(find.text('JFK'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);
  });
}
