import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SkyBookApp());
}

class SkyBookApp extends StatelessWidget {
  const SkyBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SkyBook',
      home: FlightLogPage(),
    );
  }
}

class FlightLogPage extends StatefulWidget {
  const FlightLogPage({super.key});

  @override
  State<FlightLogPage> createState() => _FlightLogPageState();
}

class _FlightLogPageState extends State<FlightLogPage> {
  final _dateController = TextEditingController();
  final _aircraftController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  List<Map<String, dynamic>> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('flights');
    if (stored != null) {
      setState(() {
        _flights = List<Map<String, dynamic>>.from(json.decode(stored));
      });
    }
  }

  Future<void> _saveFlights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('flights', json.encode(_flights));
  }

  void _addFlight() {
    final newFlight = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': _dateController.text,
      'aircraft': _aircraftController.text,
      'duration': _durationController.text,
      'notes': _notesController.text,
    };
    setState(() {
      _flights.insert(0, newFlight);
    });
    _saveFlights();
    _dateController.clear();
    _aircraftController.clear();
    _durationController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SkyBook')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _aircraftController,
              decoration: const InputDecoration(labelText: 'Aircraft'),
            ),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (hrs)'),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _addFlight, child: const Text('Add Flight')),
            Expanded(
              child: ListView.builder(
                itemCount: _flights.length,
                itemBuilder: (context, index) {
                  final flight = _flights[index];
                  final notes = flight['notes'] as String? ?? '';
                  return ListTile(
                    title: Text(
                        '${flight['date']} - ${flight['aircraft']} - ${flight['duration']} hrs'),
                    subtitle: notes.isNotEmpty ? Text(notes) : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
