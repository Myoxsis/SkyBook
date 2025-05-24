import 'dart:math';
import 'package:flutter/material.dart';

class ClassPieChart extends StatelessWidget {
  final Map<String, int> counts;
  final double size;

  const ClassPieChart({super.key, required this.counts, this.size = 150});

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = counts.values.fold<int>(0, (a, b) => a + b);
    final theme = Theme.of(context);
    final defaultColors = <Color>[
      theme.colorScheme.primary,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
    ];
    final entries = counts.entries.where((e) => e.value > 0).toList();
    double start = -pi / 2;
    final segments = <_Segment>[];
    for (int i = 0; i < entries.length; i++) {
      final sweep = entries[i].value / total * 2 * pi;
      segments.add(_Segment(
        color: defaultColors[i % defaultColors.length],
        startAngle: start,
        sweepAngle: sweep,
        label: entries[i].key,
        value: entries[i].value,
      ));
      start += sweep;
    }

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _PieChartPainter(segments,
                Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: segments
              .map(
                (s) => _LegendItem(
                  color: s.color,
                  label: '${s.label} (${s.value})',
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Segment {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final String label;
  final int value;

  _Segment({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.label,
    required this.value,
  });
}

class _PieChartPainter extends CustomPainter {
  final List<_Segment> segments;
  final Color holeColor;

  _PieChartPainter(this.segments, this.holeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    for (final s in segments) {
      final paint = Paint()..color = s.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        s.startAngle,
        s.sweepAngle,
        true,
        paint,
      );
    }

    final holePaint = Paint()..color = holeColor;
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.holeColor != holeColor;
  }
}

