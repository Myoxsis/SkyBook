import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../constants.dart';
import '../data/airport_data.dart';
import 'skybook_card.dart';

class FlightTile extends StatelessWidget {
  static const double _airportInfoWidth = 72;
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    switch (flight.travelClass) {
      case 'Premium':
        return isDark ? Colors.indigo.shade700 : Colors.indigo.shade50;
      case 'Business':
        return isDark ? Colors.teal.shade700 : Colors.teal.shade50;
      case 'First':
        return isDark ? Colors.amber.shade700 : Colors.amber.shade50;
      default:
        return isDark ? theme.colorScheme.surfaceVariant : theme.cardColor;
    }
  }

  Widget _airportColumn(BuildContext context, String code) {
    final airport = airportByCode[code];
    final city = airport?.city ?? '';
    return SizedBox(
      width: _airportInfoWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(code, style: Theme.of(context).textTheme.titleLarge),
          if (city.isNotEmpty)
            Text(
              city,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
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
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxs,
        horizontal: AppSpacing.xs,
      ),
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
                  child: Column(
                    children: [
                      if (flight.airline.isNotEmpty)
                        Text(
                          flight.airline,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      Row(
                        children: [
                          const RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.flight, size: 20),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          const Icon(Icons.circle, size: 8),
                        ],
                      ),
                      if (flight.aircraft.isNotEmpty)
                        Text(
                          flight.aircraft,
                          style: theme.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
              _airportColumn(context, flight.destination),
            ],
          ),
        ],
      ),
    );
  }
}
