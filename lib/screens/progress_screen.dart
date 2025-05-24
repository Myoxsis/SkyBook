import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../models/achievement.dart';
import '../utils/achievement_utils.dart';

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

    final achievements = calculateAchievements(_flights);

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
                        Semantics(
                          label:
                              '${a.title} progress: ${a.progress} of ${a.target}',
                          child: LinearProgressIndicator(
                            value: a.progress / a.target,
                            minHeight: 6,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
