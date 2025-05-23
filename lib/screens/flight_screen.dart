import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flight.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  List<Flight> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('flights');
    if (stored != null) {
      final List<dynamic> decoded = json.decode(stored);
      setState(() {
        _flights = decoded.map((e) => Flight.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_flights.map((f) => f.toMap()).toList());
    await prefs.setString('flights', encoded);
  }

  Future<void> _addFlight() async {
    final newFlight = await Navigator.of(context).push<Flight>(
      MaterialPageRoute(builder: (_) => const AddFlightScreen()),
    );
    if (newFlight != null) {
      setState(() {
        _flights.insert(0, newFlight);
      });
      _saveFlights();
    }
  }

  Future<void> _editFlight(int index) async {
    final updated = await Navigator.of(context).push<Flight>(
      MaterialPageRoute(
        builder: (_) => AddFlightScreen(flight: _flights[index]),
      ),
    );
    if (updated != null) {
      setState(() {
        _flights[index] = updated;
      });
      _saveFlights();
    }
  }

  void _toggleFavorite(int index) {
    final flight = _flights[index];
    setState(() {
      _flights[index] = Flight(
        id: flight.id,
        date: flight.date,
        aircraft: flight.aircraft,
        duration: flight.duration,
        notes: flight.notes,
        isFavorite: !flight.isFavorite,
      );
    });
    _saveFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flights')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlight,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          return FlightTile(
            flight: _flights[index],
            onEdit: () => _editFlight(index),
            onToggleFavorite: () => _toggleFavorite(index),
          );
        },
      ),
    );
  }
}
