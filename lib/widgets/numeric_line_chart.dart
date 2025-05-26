import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Line chart widget for numeric data keyed by month.
class NumericLineChart extends StatelessWidget {
  final Map<DateTime, num> values;
  final double height;

  const NumericLineChart({super.key, required this.values, this.height = 150});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    final sortedKeys = values.keys.toList()..sort();
    final data = [for (final k in sortedKeys) values[k]?.toDouble() ?? 0];
    final labels = [for (final k in sortedKeys) DateFormat.yMMM().format(k)];
    final lineColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _NumericLineChartPainter(data, lineColor),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((l) => Expanded(
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _NumericLineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _NumericLineChartPainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxValue = values.reduce(math.max);
    final stepX = values.length <= 1 ? size.width : size.width / (values.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = stepX * i;
      final y = size.height - (values[i] / math.max(1, maxValue) * size.height);
      points.add(Offset(x, y));
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = color;
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }

    final basePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), basePaint);
  }

  @override
  bool shouldRepaint(covariant _NumericLineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}
