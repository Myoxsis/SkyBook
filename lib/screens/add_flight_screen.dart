import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../models/aircraft.dart';
import '../models/airport.dart';
import '../data/airport_data.dart';
import '../data/aircraft_data.dart';

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
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _aircraftController = TextEditingController();

  Aircraft? _selectedAircraft;

  @override
  void initState() {
    super.initState();
    final flight = widget.flight;
    if (flight != null) {
      _dateController.text = flight.date;
      _selectedAircraft = aircraftByDisplay[flight.aircraft];
      _aircraftController.text = flight.aircraft;
      _durationController.text = flight.duration;
      _notesController.text = flight.notes;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
    } else {
      _selectedAircraft = aircrafts.first;
      _aircraftController.text = _selectedAircraft!.display;
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
      aircraft: _selectedAircraft?.display ?? _aircraftController.text,
      manufacturer: _selectedAircraft?.manufacturer ?? '',
      duration: _durationController.text,
      notes: _notesController.text,
      origin: _originController.text,
      destination: _destinationController.text,
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

  Widget _buildAirportField(TextEditingController controller, String label) {
    return Autocomplete<Airport>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return const Iterable<Airport>.empty();
        }
        return airports.where((a) =>
            a.code.toLowerCase().contains(value.text.toLowerCase()) ||
            a.name.toLowerCase().contains(value.text.toLowerCase()));
      },
      displayStringForOption: (a) => a.display,
      onSelected: (a) {
        controller.text = a.code;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text = controller.text;
        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));
        textEditingController.addListener(() {
          controller.text = textEditingController.text;
        });
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }

  Widget _buildAircraftField() {
    return Autocomplete<Aircraft>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return aircrafts;
        }
        return aircrafts.where((a) => a.display.toLowerCase().contains(value.text.toLowerCase()));
      },
      displayStringForOption: (a) => a.display,
      onSelected: (a) {
        setState(() {
          _selectedAircraft = a;
          _aircraftController.text = a.display;
        });
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text = _aircraftController.text;
        textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: textEditingController.text.length));
        textEditingController.addListener(() {
          _aircraftController.text = textEditingController.text;
        });
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(labelText: 'Aircraft'),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
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
            _buildAircraftField(),
            _buildAirportField(_originController, 'Origin'),
            _buildAirportField(_destinationController, 'Destination'),
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
