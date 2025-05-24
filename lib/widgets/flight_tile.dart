import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightTile extends StatelessWidget {
  final Flight flight;
  final VoidCallback onEdit;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const FlightTile({
    super.key,
    required this.flight,
    required this.onEdit,
    required this.onToggleFavorite,
    this.onTap,
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

  Widget _buildAirlineLogo() {
    if (flight.callsign.length >= 2) {
      final code = flight.callsign.substring(0, 2).toUpperCase();
      final url = 'https://pics.avs.io/60/60/' + code + '.png';
      return Image.network(
        url,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.flight, size: 32),
      );
    }
    return const Icon(Icons.flight, size: 32);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _colorForClass(context),
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildAirlineLogo(),
                      const SizedBox(width: 8),
                      Text(
                        flight.date,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
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
                flight.callsign.isNotEmpty ||
                flight.seatNumber.isNotEmpty ||
                flight.seatLocation.isNotEmpty) ...[
              const SizedBox(height: 2),
              Center(
                child: Text(
                  flight.callsign,
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
    ),
    );
  }
}
