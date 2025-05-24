import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../data/airport_data.dart';
import '../widgets/class_pie_chart.dart';
import '../widgets/skybook_app_bar.dart';

class StatusScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;

  const StatusScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
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

  Future<void> refresh() async {
    final flights = await FlightStorage.loadFlights();
    widget.flightsNotifier.value = flights;
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
    return entries.take(3).toList();
  }

  Map<String, int> get _airlineCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.airline.isNotEmpty) {
        counts[f.airline] = (counts[f.airline] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topAirlines {
    final entries = _airlineCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Map<String, int> get _countryCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      final origin = airportByCode[f.origin]?.country;
      final dest = airportByCode[f.destination]?.country;
      if (origin != null) counts[origin] = (counts[origin] ?? 0) + 1;
      if (dest != null) counts[dest] = (counts[dest] ?? 0) + 1;
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topCountries {
    final entries = _countryCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Map<String, int> get _classCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.travelClass.isNotEmpty) {
        counts[f.travelClass] = (counts[f.travelClass] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Status',
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
            _buildAirlineChart(),
            const SizedBox(height: 24),
            _buildCountryChart(),
            const SizedBox(height: 24),
            _buildClassChart(),
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
            return _buildBarRow(e.key, e.value, barWidth);
          })
      ],
    );
  }

  Widget _buildAirlineChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

      final top = _topAirlines;
      final maxCount = top.isNotEmpty ? top.first.value : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Airlines',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
          ...top.map((e) {
            final barWidth = e.value / maxCount;
            return _buildBarRow(e.key, e.value, barWidth);
          })
      ],
    );
  }

  Widget _buildCountryChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

      final top = _topCountries;
      final maxCount = top.isNotEmpty ? top.first.value : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Countries',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
          ...top.map((e) {
            final barWidth = e.value / maxCount;
            return _buildBarRow(e.key, e.value, barWidth);
          })
      ],
    );
  }

  Widget _buildClassChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Class Distribution',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ClassPieChart(counts: _classCount),
      ],
    );
  }

  Widget _buildBarRow(String label, int value, double fraction) {
    final barColor = Theme.of(context).colorScheme.primary;
    final backgroundColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.12);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Semantics(
        label: '$label: $value',
        child: Row(
          children: [
            SizedBox(width: 100, child: Text(label)),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 20,
                    color: backgroundColor,
                  ),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      height: 20,
                      color: barColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(value.toString()),
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
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: colors.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: colors.onSurface),
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
