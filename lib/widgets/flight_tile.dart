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

  Color _chipColorForClass(BuildContext context) {
    switch (flight.travelClass) {
      case 'Premium':
        return Colors.indigo;
      case 'Business':
        return Colors.teal;
      case 'First':
        return Colors.amber;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _colorForClass(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (flight.travelClass) {
      case 'Premium':
        return isDark ? Colors.indigo.shade700 : Colors.indigo.shade50;
      case 'Business':
        return isDark ? Colors.teal.shade700 : Colors.teal.shade50;
      case 'First':
        return isDark ? Colors.amber.shade700 : Colors.amber.shade50;
      default:
        return Theme.of(context).cardColor;
    }
  }

  Widget _airportColumn(BuildContext context, String code) {
    final airport = airportByCode[code];
    final city = airport?.city ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(code, style: Theme.of(context).textTheme.titleLarge),
        if (city.isNotEmpty)
          Text(city, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _travelClassChip(BuildContext context) {
    if (flight.travelClass.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _chipColorForClass(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        flight.travelClass,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.white),
      ),
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
              Row(
                children: [
                  _travelClassChip(context),
                  IconButton(
                    icon: Icon(
                      flight.isFavorite ? Icons.star : Icons.star_border,
                      semanticLabel: flight.isFavorite
                          ? 'Unfavorite flight'
                          : 'Favorite flight',
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ],
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
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Icon(Icons.arrow_right_alt, size: 20),
                      Expanded(child: Divider(thickness: 1)),
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
              const Icon(Icons.flight, size: 16, semanticLabel: 'Aircraft'),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  flight.aircraft,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
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
