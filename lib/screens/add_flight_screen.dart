import 'package:flutter/material.dart';
import '../models/flight.dart';

class AddFlightScreen extends StatefulWidget {
  const AddFlightScreen({super.key});

  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _dateController = TextEditingController();
  final _aircraftController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  void _submit() {
    final flight = Flight(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _dateController.text,
      aircraft: _aircraftController.text,
      duration: _durationController.text,
      notes: _notesController.text,
    );
    Navigator.of(context).pop(flight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Flight')),
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
            ElevatedButton(onPressed: _submit, child: const Text('Add Flight')),
          ],
        ),
      ),
    );
  }
}
