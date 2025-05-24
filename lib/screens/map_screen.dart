import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
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

    for (final f in _flights) {
      final origin = airportByCode[f.origin];
      final dest = airportByCode[f.destination];
      if (origin != null && dest != null) {
        final start = LatLng(origin.latitude, origin.longitude);
        final end = LatLng(dest.latitude, dest.longitude);
        markers.addAll([
          Marker(
            point: start,
            width: 30,
            height: 30,
            builder: (_) => const Icon(Icons.flight_takeoff, color: Colors.blue),
          ),
          Marker(
            point: end,
            width: 30,
            height: 30,
            builder: (_) => const Icon(Icons.flight_land, color: Colors.red),
          ),
        ]);
        lines.add(Polyline(points: [start, end], color: Colors.blue, strokeWidth: 2));
      }
    }

    final center = markers.isNotEmpty ? markers.first.point : LatLng(20, 0);

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
        options: MapOptions(center: center, zoom: 2),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayer(polylines: lines),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
