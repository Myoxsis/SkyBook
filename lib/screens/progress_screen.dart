import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';

class ProgressScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  const ProgressScreen({super.key, required this.onOpenSettings});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
        onRefresh: _loadFlights,
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
