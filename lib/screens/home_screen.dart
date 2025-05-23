import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flight.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SkyBook')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlight,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          return FlightTile(flight: _flights[index]);
        },
      ),
    );
  }
}
