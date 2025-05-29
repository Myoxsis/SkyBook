import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/airport_data.dart';
import 'skybook_card.dart';

/// Displays the origin and destination airports in a single card.
class OriginDestinationCard extends StatelessWidget {
  static const double _airportInfoWidth = 72;

  final String origin;
  final String destination;

  const OriginDestinationCard({
    super.key,
    required this.origin,
    required this.destination,
  });

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

  @override
  Widget build(BuildContext context) {
    return SkyBookCard(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _airportColumn(context, origin),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: const [
                  RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.flight, size: 20),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                  Icon(Icons.circle, size: 8),
                ],
              ),
            ),
          ),
          _airportColumn(context, destination),
        ],
      ),
    );
  }
}
