import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';
import 'settings_screen.dart';

class FlightScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  const FlightScreen({super.key, required this.onOpenSettings});

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
    final flights = await FlightStorage.loadFlights();
    setState(() {
      _flights = flights;
    });
  }

  Future<void> _saveFlights() async {
    await FlightStorage.saveFlights(_flights);
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
      appBar: AppBar(
        title: const Text('Flights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlight,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Text('Map placeholder'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _flights.length,
              itemBuilder: (context, index) {
                return FlightTile(
                  flight: _flights[index],
                  onEdit: () => _editFlight(index),
                  onToggleFavorite: () => _toggleFavorite(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
