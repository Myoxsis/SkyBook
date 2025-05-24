import 'package:flutter/material.dart';
import '../models/flight.dart';

class AddFlightScreen extends StatefulWidget {
  final Flight? flight;

  const AddFlightScreen({super.key, this.flight});

  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _dateController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  // List of aircraft types operated by the airline.
  final List<String> _aircraftOptions = [
    'Airbus A320',
    'Airbus A321',
    'Airbus A330',
    'Airbus A350',
    'Boeing 737',
    'Boeing 747',
    'Boeing 757',
    'Boeing 767',
    'Boeing 777',
    'Boeing 787',
  ];

  String? _selectedAircraft;

  @override
  void initState() {
    super.initState();
    final flight = widget.flight;
    if (flight != null) {
      _dateController.text = flight.date;
      _selectedAircraft = flight.aircraft;
      _durationController.text = flight.duration;
      _notesController.text = flight.notes;
    } else {
      _selectedAircraft = _aircraftOptions.first;
    }
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.now();
    if (widget.flight != null) {
      final parsed = DateTime.tryParse(widget.flight!.date);
      if (parsed != null) initial = parsed;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        _dateController.text = formatted;
      });
    }
  }

  void _submit() {
    final flight = Flight(
      id: widget.flight?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _dateController.text,
      aircraft: _selectedAircraft ?? '',
      duration: _durationController.text,
      notes: _notesController.text,
      isFavorite: widget.flight?.isFavorite ?? false,
    );
    Navigator.of(context).pop(flight);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flight'),
        content: const Text('Are you sure you want to delete this flight?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flight == null ? 'Add Flight' : 'Edit Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date'),
              onTap: _pickDate,
            ),
            DropdownButtonFormField<String>(
              value: _selectedAircraft,
              items: _aircraftOptions
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedAircraft = val;
                });
              },
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
            ElevatedButton(
              onPressed: _submit,
              child: Text(widget.flight == null ? 'Add Flight' : 'Save Changes'),
            ),
            if (widget.flight != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _delete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Delete Flight'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
