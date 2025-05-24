import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../models/achievement.dart';
import '../data/airport_data.dart';
import 'package:latlong2/latlong.dart';

class ProgressScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;

  const ProgressScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;
  final Distance _distance = const Distance();

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

  Future<void> _reloadFromStorage() async {
    final flights = await FlightStorage.loadFlights();
    widget.flightsNotifier.value = flights;
  }

  Achievement _progress(
    String id,
    String title,
    String description,
    int current,
    int target,
  ) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      target: target,
      progress: current.clamp(0, target),
      achieved: current >= target,
    );
  }

  List<Achievement> _calculateAchievements() {
    final totalFlights = _flights.length;

    double totalKm = 0;
    final airportsVisited = <String>{};
    final countriesVisited = <String>{};

    for (final f in _flights) {
      final origin = airportByCode[f.origin];
      final dest = airportByCode[f.destination];
      if (origin != null) {
        airportsVisited.add(origin.code);
        countriesVisited.add(origin.country);
      }
      if (dest != null) {
        airportsVisited.add(dest.code);
        countriesVisited.add(dest.country);
      }
      if (origin != null && dest != null) {
        final start = LatLng(origin.latitude, origin.longitude);
        final end = LatLng(dest.latitude, dest.longitude);
        totalKm += _distance.as(LengthUnit.Kilometer, start, end);
      }
    }

    return [
      _progress('firstFlight', 'First Flight', 'Log 1 flight', totalFlights, 1),
      _progress(
          'frequentFlyer', 'Frequent Flyer', 'Log 50 flights', totalFlights, 50),
      _progress(
          'globeTrotter', 'Globe Trotter', 'Log 100 flights', totalFlights, 100),
      _progress('shortHaul', 'Short Haul Hero', 'Travel 1,000 km',
          totalKm.round(), 1000),
      _progress('aroundWorld', 'Around the World', 'Travel 40,075 km',
          totalKm.round(), 40075),
      _progress('longHaul', 'Long Haul Legend', 'Travel 100,000 km',
          totalKm.round(), 100000),
      _progress('newHorizons', 'New Horizons', 'Visit 5 different countries',
          countriesVisited.length, 5),
      _progress('airportAddict', 'Airport Addict', 'Land at 50 different airports',
          airportsVisited.length, 50),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reloadFromStorage,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    final achievements = _calculateAchievements();

    List<Widget> items = achievements
        .map(
          (a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(a.title),
                    content: Text(a.description),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.emoji_events,
                      color: a.achieved ? Colors.amber : Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(
                          value: a.progress / a.target,
                          minHeight: 6,
                        ),
                        Text('${a.progress}/${a.target}',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                  if (a.achieved)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}
