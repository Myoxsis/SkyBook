import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';
import 'settings_screen.dart';

class FlightScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Future<void> Function() onFlightsChanged;

  const FlightScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
    required this.onFlightsChanged,
  });

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
    _listener = () {
      setState(() {
        _flights = widget.flightsNotifier.value;
      });
    };
    widget.flightsNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    widget.flightsNotifier.removeListener(_listener);
    super.dispose();
  }

  Future<void> _addFlight() async {
    final newFlight = await Navigator.of(context).push<Flight>(
      MaterialPageRoute(builder: (_) => const AddFlightScreen()),
    );
    if (newFlight != null) {
      final updated = List<Flight>.from(_flights)..insert(0, newFlight);
      widget.flightsNotifier.value = updated;
      await widget.onFlightsChanged();
    }
  }

  Future<void> _editFlight(int index) async {
    final updated = await Navigator.of(context).push<Flight>(
      MaterialPageRoute(
        builder: (_) => AddFlightScreen(flight: _flights[index]),
      ),
    );
    if (updated != null) {
      final list = List<Flight>.from(_flights);
      list[index] = updated;
      widget.flightsNotifier.value = list;
      await widget.onFlightsChanged();
    }
  }

  void _toggleFavorite(int index) {
    final flight = _flights[index];
    final list = List<Flight>.from(_flights);
    list[index] = Flight(
      id: flight.id,
      date: flight.date,
      aircraft: flight.aircraft,
      duration: flight.duration,
      notes: flight.notes,
      isFavorite: !flight.isFavorite,
    );
    widget.flightsNotifier.value = list;
    widget.onFlightsChanged();
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
