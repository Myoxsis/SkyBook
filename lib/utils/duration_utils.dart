import 'package:flutter/material.dart';

/// Parses a duration string.
///
/// Supports either decimal hours (e.g. `1.5`) or
/// formatted strings like `2h 30m`.
Duration parseDuration(String value) {
  final trimmed = value.trim();
  final match = RegExp(r'^(\d+)h(?:\s*(\d+)m)?$').firstMatch(trimmed);
  if (match != null) {
    final h = int.parse(match.group(1)!);
    final m = match.group(2) != null ? int.parse(match.group(2)!) : 0;
    return Duration(hours: h, minutes: m);
  }

  final d = double.tryParse(trimmed);
  if (d != null) {
    final h = d.floor();
    final m = ((d - h) * 60).round();
    return Duration(hours: h, minutes: m);
  }
  return Duration.zero;
}

/// Converts a [Duration] to a human readable string like `2h 30m`.
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  if (m == 0) return "${h}h";
  return "${h}h ${m}m";
}

/// Parses [value] and returns the duration in hours as a double.
/// Useful for calculations where a numeric value is needed.
double parseDurationHours(String value) {
  final d = parseDuration(value);
  return d.inMinutes / 60.0;
}
