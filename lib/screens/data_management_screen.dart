import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../utils/flight_serialization.dart';
import '../widgets/skybook_app_bar.dart';

class DataManagementScreen extends StatefulWidget {
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Future<void> Function() onFlightsChanged;

  const DataManagementScreen({
    super.key,
    required this.flightsNotifier,
    required this.onFlightsChanged,
  });

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final TextEditingController _controller = TextEditingController();

  void _exportJson() {
    final data = FlightSerialization.toJson(widget.flightsNotifier.value);
    Share.share(data, subject: 'SkyBook Flights JSON');
  }

  void _exportCsv() {
    final data = FlightSerialization.toCsv(widget.flightsNotifier.value);
    Share.share(data, subject: 'SkyBook Flights CSV');
  }

  Future<void> _importJson() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      final flights = FlightSerialization.fromJson(text);
      widget.flightsNotifier.value = flights;
      await FlightStorage.saveFlights(flights);
      await widget.onFlightsChanged();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flights imported from JSON')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid JSON data')),
        );
      }
    }
  }

  Future<void> _importCsv() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      final flights = FlightSerialization.fromCsv(text);
      widget.flightsNotifier.value = flights;
      await FlightStorage.saveFlights(flights);
      await widget.onFlightsChanged();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flights imported from CSV')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid CSV data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SkyBookAppBar(title: 'Import / Export'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: _exportJson,
            child: const Text('Export as JSON'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _exportCsv,
            child: const Text('Export as CSV'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 5,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Import data',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _importJson,
                  child: const Text('Import JSON'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _importCsv,
                  child: const Text('Import CSV'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
