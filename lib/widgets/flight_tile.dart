import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../constants.dart';
import '../data/airport_data.dart';
import 'skybook_card.dart';

class FlightTile extends StatelessWidget {
  final Flight flight;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const FlightTile({
    super.key,
    required this.flight,
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

  Widget _airportColumn(BuildContext context, String code) {
    final airport = airportByCode[code];
    final city = airport?.name ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(code, style: Theme.of(context).textTheme.titleMedium),
        if (city.isNotEmpty)
          Text(city, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkyBookCard(
      color: _colorForClass(context),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      padding: const EdgeInsets.all(AppSpacing.xxs),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.date,
                style: theme.textTheme.bodyLarge,
              ),
              IconButton(
                icon: Icon(
                  flight.isFavorite ? Icons.star : Icons.star_border,
                  semanticLabel:
                      flight.isFavorite ? 'Unfavorite flight' : 'Favorite flight',
                ),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _airportColumn(context, flight.origin),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 16),
                      const SizedBox(width: 4),
                      const Expanded(child: Divider(thickness: 1)),
                      const SizedBox(width: 4),
                      const Icon(Icons.circle, size: 8),
                    ],
                  ),
                ),
              ),
              _airportColumn(context, flight.destination),
            ],
          ),
          const SizedBox(height: 4),
          if (flight.airline.isNotEmpty)
            Text(
              flight.airline,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, semanticLabel: 'Duration'),
              const SizedBox(width: 4),
              Text('${flight.duration}h', style: theme.textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
