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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(flight.date,
                    style: Theme.of(context).textTheme.bodyLarge),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text('${flight.duration}h'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(flight.aircraft,
                style: Theme.of(context).textTheme.titleMedium),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(notes),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
            )
          ],
        ),
      ),
    );
  }
}
