import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';
import 'settings_screen.dart';
import 'flight_detail_screen.dart';
import '../widgets/skybook_app_bar.dart';

class FlightScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final ValueNotifier<bool> premiumNotifier;
  final Future<void> Function() onFlightsChanged;

  const FlightScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
    required this.premiumNotifier,
    required this.onFlightsChanged,
  });

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

enum _FlightSortOrder { newestFirst, oldestFirst }

class _FlightScreenState extends State<FlightScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;
  _FlightSortOrder _sortOrder = _FlightSortOrder.newestFirst;

  void _sortFlights() {
    _flights.sort((a, b) {
      final da = DateTime.tryParse(a.date);
      final db = DateTime.tryParse(b.date);
      if (da == null || db == null) return 0;
      return _sortOrder == _FlightSortOrder.newestFirst
          ? db.compareTo(da)
          : da.compareTo(db);
    });
  }

  @override
  void initState() {
    super.initState();
    _flights = List<Flight>.from(widget.flightsNotifier.value);
    _sortFlights();
    _listener = () {
      setState(() {
        _flights = List<Flight>.from(widget.flightsNotifier.value);
        _sortFlights();
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
      _flights = List<Flight>.from(_flights)..add(newFlight);
      _sortFlights();
      widget.flightsNotifier.value = List<Flight>.from(_flights);
      await widget.onFlightsChanged();
    }
  }

  Future<void> _editFlight(int index) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => AddFlightScreen(flight: _flights[index]),
      ),
    );
    if (result is Flight) {
      _flights[index] = result;
      _sortFlights();
      widget.flightsNotifier.value = List<Flight>.from(_flights);
      await widget.onFlightsChanged();
    } else if (result == 'delete') {
      _flights = List<Flight>.from(_flights)..removeAt(index);
      widget.flightsNotifier.value = List<Flight>.from(_flights);
      await widget.onFlightsChanged();
    }
  }

  void _toggleFavorite(int index) {
    final flight = _flights[index];
    _flights[index] = flight.copyWith(isFavorite: !flight.isFavorite);
    widget.flightsNotifier.value = List<Flight>.from(_flights);
    widget.onFlightsChanged();
  }

  Future<void> _viewFlight(int index) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => FlightDetailScreen(
          flight: _flights[index],
          premiumNotifier: widget.premiumNotifier,
        ),
      ),
    );
    if (result is Flight) {
      _flights[index] = result;
      _sortFlights();
      widget.flightsNotifier.value = List<Flight>.from(_flights);
      await widget.onFlightsChanged();
    } else if (result == 'delete') {
      _flights = List<Flight>.from(_flights)..removeAt(index);
      widget.flightsNotifier.value = List<Flight>.from(_flights);
      await widget.onFlightsChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Flights',
        actions: [
          PopupMenuButton<_FlightSortOrder>(
            icon: const Icon(Icons.sort),
            onSelected: (order) {
              setState(() {
                _sortOrder = order;
                _sortFlights();
              });
              widget.flightsNotifier.value = List<Flight>.from(_flights);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _FlightSortOrder.newestFirst,
                child: Text('Most Recent'),
              ),
              PopupMenuItem(
                value: _FlightSortOrder.oldestFirst,
                child: Text('Oldest'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
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
            onTap: () => _viewFlight(index),
          );
        },
      ),
    );
  }
}
