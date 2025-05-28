import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Displays flight counts for each day of week as a vertical bar chart.
class DayOfWeekBarChart extends StatelessWidget {
  final Map<String, int> counts;
  final double height;

  const DayOfWeekBarChart({
    super.key,
    required this.counts,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) return const SizedBox.shrink();
    final order = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxCount =
        counts.values.isNotEmpty ? counts.values.reduce(math.max) : 1;
    final barColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: order.map((d) {
          final count = counts[d] ?? 0;
          final heightFactor = maxCount == 0 ? 0.0 : count / maxCount;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: heightFactor,
                      widthFactor: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(d, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
