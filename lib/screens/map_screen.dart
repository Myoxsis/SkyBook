import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../models/flight.dart';
import '../models/airport.dart';
import '../data/airport_data.dart';
import '../widgets/skybook_app_bar.dart';

class MapScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;

  const MapScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;
  final MapController _controller = MapController();
  LatLng _center = LatLng(20, 0);
  double _zoom = 2;

  void _showAirportInfo(Airport airport) {
    final related = _flights
        .where((f) => f.origin == airport.code || f.destination == airport.code)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(airport.display,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(airport.country,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                if (related.isNotEmpty) ...[
                  Text('Flights',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  for (final f in related)
                    ListTile(
                      dense: true,
                      title: Text('${f.origin} → ${f.destination}'),
                      subtitle: Text('${f.date} • ${f.aircraft}'),
                    ),
                ] else
                  const Text('No flights for this airport'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<LatLng> _arcPoints(LatLng start, LatLng end) {
    const steps = 50;
    final latDiff = end.latitude - start.latitude;
    final lonDiff = end.longitude - start.longitude;
    final distance = math.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    if (distance == 0) {
      return [start, end];
    }
    final perpLat = -lonDiff;
    final perpLon = latDiff;
    final norm = math.sqrt(perpLat * perpLat + perpLon * perpLon);
    if (norm == 0) {
      return [start, end];
    }
    final offsetLat = perpLat / norm;
    final offsetLon = perpLon / norm;
    final amp = distance * 0.2;

    final pts = <LatLng>[];
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final curve = math.sin(math.pi * t);
      final lat = start.latitude + latDiff * t + offsetLat * amp * curve;
      final lon = start.longitude + lonDiff * t + offsetLon * amp * curve;
      pts.add(LatLng(lat, lon));
    }
    return pts;
  }

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
    if (_flights.isNotEmpty) {
      final origin = airportByCode[_flights.first.origin];
      if (origin != null) {
        _center = LatLng(origin.latitude, origin.longitude);
      }
    }
    _listener = () {
      setState(() {
        _flights = widget.flightsNotifier.value;
      });
    };
    widget.flightsNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    widget.flightsNotifier.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];
    final lines = <Polyline>[];

    final usedCodes = <String>{};
    for (final f in _flights) {
      if (f.origin.isNotEmpty) usedCodes.add(f.origin);
      if (f.destination.isNotEmpty) usedCodes.add(f.destination);
    }

    for (final code in usedCodes) {
      final airport = airportByCode[code];
      if (airport == null) continue;
      markers.add(
        Marker(
          point: LatLng(airport.latitude, airport.longitude),
          width: 30,
          height: 30,
          builder: (_) => GestureDetector(
            onTap: () => _showAirportInfo(airport),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.flight, size: 16, color: Colors.white),
            ),
          ),
        ),
      );
    }

    for (final f in _flights) {
      final origin = airportByCode[f.origin];
      final dest = airportByCode[f.destination];
      if (origin != null && dest != null) {
        final start = LatLng(origin.latitude, origin.longitude);
        final end = LatLng(dest.latitude, dest.longitude);
        lines.add(
          Polyline(
            points: _arcPoints(start, end),
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 3,
          ),
        );
      }
    }

    if (_center == LatLng(20, 0) && markers.isNotEmpty) {
      _center = markers.first.point;
    }

    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Map',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          center: _center,
          zoom: _zoom,
          onPositionChanged: (pos, _) {
            _center = pos.center ?? _center;
            _zoom = pos.zoom ?? _zoom;
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayer(polylines: lines),
          MarkerLayer(markers: markers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'mapZoomIn',
            mini: true,
            onPressed: () {
              _controller.move(_controller.center, _controller.zoom + 1);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'mapZoomOut',
            mini: true,
            onPressed: () {
              _controller.move(_controller.center, _controller.zoom - 1);
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
