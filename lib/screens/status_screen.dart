import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';

class StatusScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const StatusScreen({super.key, required this.onToggleTheme});

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

  int get _favoriteCount =>
      _flights.where((f) => f.isFavorite).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GridView.count(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _StatusTile(
              icon: Icons.flight,
              label: 'Total flights',
              value: _flights.length.toString(),
            ),
            _StatusTile(
              icon: Icons.schedule,
              label: 'Total duration',
              value: '${_totalDuration.toStringAsFixed(1)} hrs',
            ),
            _StatusTile(
              icon: Icons.star,
              label: 'Favorites',
              value: _favoriteCount.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
