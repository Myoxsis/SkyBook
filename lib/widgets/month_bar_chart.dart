import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

/// Displays numeric values per month as vertical bars.
class MonthBarChart extends StatelessWidget {
  final Map<DateTime, num> values;
  final double height;

  const MonthBarChart({super.key, required this.values, this.height = 150});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    final sortedKeys = values.keys.toList()..sort();
    final maxValue =
        values.values.isNotEmpty ? values.values.reduce((a, b) => a > b ? a : b).toDouble() : 1.0;
    final barColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: sortedKeys.map((k) {
          final v = values[k]!.toDouble();
          final heightFactor = maxValue == 0 ? 0.0 : v / maxValue;
          final label = intl.DateFormat.MMM().format(k);
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  v.toStringAsFixed(0),
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
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
