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

  int get _favoriteCount =>
      _flights.where((f) => f.isFavorite).length;

  Map<String, int> get _aircraftCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      counts[f.aircraft] = (counts[f.aircraft] ?? 0) + 1;
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topAircraft {
    final entries = _aircraftCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(10).toList();
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
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
              ],
            ),
            const SizedBox(height: 24),
            _buildAircraftChart(),
            const SizedBox(height: 24),
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAircraftChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    final top = _topAircraft;
    final maxCount = top.isNotEmpty ? top.first.value : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Aircraft',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...top.map((e) {
          final barWidth = e.value / maxCount;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 100, child: Text(e.key)),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                      FractionallySizedBox(
                        widthFactor: barWidth,
                        child: Container(
                          height: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(e.value.toString()),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _buildProgressSection() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    final achievements = <String>[];
    if (_flights.length >= 1) achievements.add('1st flight logged');
    if (_flights.length >= 10) achievements.add('10 flights logged');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...achievements.map((a) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $a'),
            )),
      ],
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
