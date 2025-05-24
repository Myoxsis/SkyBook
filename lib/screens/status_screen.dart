import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';

class StatusScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  const StatusScreen({super.key, required this.onOpenSettings});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Flight> _flights = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final flights = await FlightStorage.loadFlights();
    setState(() {
      _flights = flights;
    });
  }

  double get _totalDuration {
    return _flights.fold(0.0, (previousValue, element) {
      final dur = double.tryParse(element.duration) ?? 0;
      return previousValue + dur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Total flights: ${_flights.length}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Total duration: ${_totalDuration.toStringAsFixed(1)} hrs', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Favorites: ${_flights.where((f) => f.isFavorite).length}', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
