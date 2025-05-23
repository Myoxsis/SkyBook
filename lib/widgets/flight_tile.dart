import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightTile extends StatelessWidget {
  final Flight flight;

  const FlightTile({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final notes = flight.notes;
    return ListTile(
      title: Text('${flight.date} - ${flight.aircraft} - ${flight.duration} hrs'),
      subtitle: notes.isNotEmpty ? Text(notes) : null,
    );
  }
}
