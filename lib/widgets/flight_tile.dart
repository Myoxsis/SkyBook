import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightTile extends StatelessWidget {
  final Flight flight;
  final VoidCallback onEdit;
  final VoidCallback onToggleFavorite;

  const FlightTile({
    super.key,
    required this.flight,
    required this.onEdit,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final notes = flight.notes;
    return ListTile(
      title: Text('${flight.date} - ${flight.aircraft} - ${flight.duration} hrs'),
      subtitle: notes.isNotEmpty ? Text(notes) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              flight.isFavorite ? Icons.star : Icons.star_border,
            ),
            onPressed: onToggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
