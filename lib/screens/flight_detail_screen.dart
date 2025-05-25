import 'package:flutter/material.dart';

import '../models/flight.dart';
import 'add_flight_screen.dart';
import '../widgets/skybook_app_bar.dart';

class FlightDetailScreen extends StatelessWidget {
  final Flight flight;
  const FlightDetailScreen({super.key, required this.flight});

  Future<void> _edit(BuildContext context) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => AddFlightScreen(flight: flight)),
    );
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  Widget _tile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _tile('Date', flight.date),
      _tile('From', flight.origin),
      _tile('To', flight.destination),
      _tile('Aircraft', flight.aircraft),
    ];

    if (flight.airline.isNotEmpty) {
      items.add(_tile('Airline', flight.airline));
    }
    if (flight.callsign.isNotEmpty) {
      items.add(_tile('Flight No.', flight.callsign));
    }
    if (flight.duration.isNotEmpty) {
      items.add(_tile('Duration', '${flight.duration}h'));
    }
    if (flight.distanceKm > 0) {
      items.add(_tile('Distance', '${flight.distanceKm.round()} km'));
    }
    if (flight.carbonKg > 0) {
      items.add(_tile('Carbon', '${flight.carbonKg.round()} kg CO₂'));
    }
    if (flight.travelClass.isNotEmpty) {
      items.add(_tile('Class', flight.travelClass));
    }
    if (flight.seatNumber.isNotEmpty || flight.seatLocation.isNotEmpty) {
      final seat = [flight.seatNumber, flight.seatLocation].where((e) => e.isNotEmpty).join(' ');
      items.add(_tile('Seat', seat));
    }
    if (flight.notes.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(flight.notes),
        ),
      );
    }

    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Flight Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items,
      ),
    );
  }
}
