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

  Color _colorForClass(BuildContext context) {
    switch (flight.travelClass) {
      case 'Premium':
        return Colors.indigo.shade50;
      case 'Business':
        return Colors.teal.shade50;
      case 'First':
        return Colors.amber.shade50;
      default:
        return Theme.of(context).cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _colorForClass(context),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.date,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  icon: Icon(
                    flight.isFavorite ? Icons.star : Icons.star_border,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                '${flight.origin} → ${flight.destination}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                flight.aircraft,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (flight.travelClass.isNotEmpty ||
                flight.seatNumber.isNotEmpty ||
                flight.seatLocation.isNotEmpty) ...[
              const SizedBox(height: 2),
              Center(
                child: Text(
                  [
                    flight.travelClass,
                    flight.seatNumber,
                    flight.seatLocation
                  ].where((e) => e.isNotEmpty).join(' • '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 4),
                    Text('${flight.duration}h'),
                  ],
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
