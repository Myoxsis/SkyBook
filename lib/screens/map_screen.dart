import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../models/flight.dart';
import '../data/airport_data.dart';

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
  LatLng _center = const LatLng(20, 0);
  double _zoom = 2;

  List<LatLng> _arcPoints(LatLng start, LatLng end) {
    const steps = 50;
    final latDiff = end.latitude - start.latitude;
    final lonDiff = end.longitude - start.longitude;
    final distance = math.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    final perpLat = -lonDiff;
    final perpLon = latDiff;
    final norm = math.sqrt(perpLat * perpLat + perpLon * perpLon);
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

    for (final airport in airports) {
      markers.add(
        Marker(
          point: LatLng(airport.latitude, airport.longitude),
          width: 30,
          height: 30,
          builder: (_) => const Icon(Icons.location_on, color: Colors.purple),
        ),
      );
    }

    for (final f in _flights) {
      final origin = airportByCode[f.origin];
      final dest = airportByCode[f.destination];
      if (origin != null && dest != null) {
        final start = LatLng(origin.latitude, origin.longitude);
        final end = LatLng(dest.latitude, dest.longitude);
        lines.add(Polyline(points: _arcPoints(start, end), color: Colors.blue, strokeWidth: 2));
      }
    }

    if (_center == const LatLng(20, 0) && markers.isNotEmpty) {
      _center = markers.first.point;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
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
