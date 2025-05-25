import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightLineChart extends StatelessWidget {
  final Map<DateTime, int> counts;
  final double height;

  const FlightLineChart({super.key, required this.counts, this.height = 150});

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) return const SizedBox.shrink();
    final sortedKeys = counts.keys.toList()..sort();
    final data = [for (final k in sortedKeys) counts[k] ?? 0];
    final labels = [for (final k in sortedKeys) DateFormat.yMMM().format(k)];
    final lineColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineChartPainter(data, lineColor),
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

class _LineChartPainter extends CustomPainter {
  final List<int> counts;
  final Color color;

  _LineChartPainter(this.counts, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (counts.isEmpty) return;
    final maxCount = counts.reduce(math.max);
    final stepX = counts.length <= 1 ? size.width : size.width / (counts.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < counts.length; i++) {
      final x = stepX * i;
      final y = size.height - (counts[i] / math.max(1, maxCount) * size.height);
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

    // Draw baseline
    final basePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), basePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.counts != counts || oldDelegate.color != color;
  }
}
