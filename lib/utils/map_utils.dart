import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Utility methods for map related calculations.
class MapUtils {
  /// Generates intermediate points describing a curved line between [start]
  /// and [end]. Handles dateline crossing so the curve always follows the
  /// shorter path.
  static List<LatLng> arcPoints(LatLng start, LatLng end) {
    const steps = 50;
    var startLon = start.longitude;
    var endLon = end.longitude;

    // Adjust longitudes when crossing the dateline so the difference is <180°.
    if ((endLon - startLon).abs() > 180) {
      if (startLon > endLon) {
        endLon += 360;
      } else {
        startLon += 360;
      }
    }

    final latDiff = end.latitude - start.latitude;
    final lonDiff = endLon - startLon;
    final distance = math.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    if (distance == 0) return [start, end];

    final perpLat = -lonDiff;
    final perpLon = latDiff;
    final norm = math.sqrt(perpLat * perpLat + perpLon * perpLon);
    if (norm == 0) return [start, end];
    final offsetLat = perpLat / norm;
    final offsetLon = perpLon / norm;
    final amp = distance * 0.2;

    final pts = <LatLng>[];
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final curve = math.sin(math.pi * t);
      final lat = start.latitude + latDiff * t + offsetLat * amp * curve;
      var lon = startLon + lonDiff * t + offsetLon * amp * curve;
      // Wrap longitude back to [-180, 180] range.
      if (lon > 180) lon -= 360;
      if (lon < -180) lon += 360;
      pts.add(LatLng(lat, lon));
    }
    return pts;
  }

  /// Data class holding the map [center] and [zoom] level.
  static MapView viewForPoints(List<LatLng> points,
      {double minZoom = 2.0, double maxZoom = 16.0}) {
    if (points.isEmpty) {
      return MapView(center: LatLng(0, 0), zoom: 3);
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLon) minLon = p.longitude;
      if (p.longitude > maxLon) maxLon = p.longitude;
    }

    double diffLon = (maxLon - minLon).abs();
    double centerLon;
    if (diffLon > 180) {
      diffLon = 360 - diffLon;
      centerLon = (minLon + maxLon + 360) / 2;
      if (centerLon > 180) centerLon -= 360;
    } else {
      centerLon = (minLon + maxLon) / 2;
    }

    final center = LatLng((minLat + maxLat) / 2, centerLon);

    final diffLat = (maxLat - minLat).abs();
    final diff = math.max(diffLat, diffLon);
    var zoom = (math.log(360 / diff) / math.ln2) + 1;
    if (zoom.isNaN || zoom.isInfinite) zoom = 3;
    zoom = zoom.clamp(minZoom, maxZoom);

    return MapView(center: center, zoom: zoom);
  }
}

/// Simple holder for a map's center point and zoom level.
class MapView {
  final LatLng center;
  final double zoom;

  const MapView({required this.center, required this.zoom});
}
