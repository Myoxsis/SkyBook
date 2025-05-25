import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../models/flight.dart';
import '../data/airport_data.dart';
import 'add_flight_screen.dart';
import '../widgets/skybook_app_bar.dart';

class FlightDetailScreen extends StatelessWidget {
  final Flight flight;
  const FlightDetailScreen({super.key, required this.flight});

  Future<void> _edit(BuildContext context) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => AddFlightScreen(flight: flight)),
    );
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  Widget _tile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  List<LatLng> _arcPoints(LatLng start, LatLng end) {
    const steps = 50;
    final latDiff = end.latitude - start.latitude;
    final lonDiff = end.longitude - start.longitude;
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
      final lon = start.longitude + lonDiff * t + offsetLon * amp * curve;
      pts.add(LatLng(lat, lon));
    }
    return pts;
  }

  Widget _buildMap(BuildContext context) {
    final origin = airportByCode[flight.origin];
    final dest = airportByCode[flight.destination];
    if (origin == null || dest == null) return const SizedBox.shrink();

    final start = LatLng(origin.latitude, origin.longitude);
    final end = LatLng(dest.latitude, dest.longitude);
    final center = LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );

    final markers = [
      Marker(
        point: start,
        width: 30,
        height: 30,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.flight_takeoff, size: 16, color: Colors.white),
        ),
      ),
      Marker(
        point: end,
        width: 30,
        height: 30,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.flight_land, size: 16, color: Colors.white),
        ),
      ),
    ];

    final lines = [
      Polyline(
        points: _arcPoints(start, end),
        color: Theme.of(context).colorScheme.secondary,
        strokeWidth: 3,
      )
    ];

    return SizedBox(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          center: center,
          zoom: 3,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildMap(context),
      const SizedBox(height: 16),
      _tile('Date', flight.date),
      _tile('From', flight.origin),
      _tile('To', flight.destination),
      _tile('Aircraft', flight.aircraft),
    ];

    if (flight.airline.isNotEmpty) {
      items.add(_tile('Airline', flight.airline));
    }
    if (flight.callsign.isNotEmpty) {
      items.add(_tile('Flight No.', flight.callsign));
    }
    if (flight.duration.isNotEmpty) {
      items.add(_tile('Duration', '${flight.duration}h'));
    }
    if (flight.distanceKm > 0) {
      items.add(_tile('Distance', '${flight.distanceKm.round()} km'));
    }
    if (flight.carbonKg > 0) {
      items.add(_tile('Carbon', '${flight.carbonKg.round()} kg CO₂'));
    }
    if (flight.travelClass.isNotEmpty) {
      items.add(_tile('Class', flight.travelClass));
    }
    if (flight.seatNumber.isNotEmpty || flight.seatLocation.isNotEmpty) {
      final seat = [flight.seatNumber, flight.seatLocation].where((e) => e.isNotEmpty).join(' ');
      items.add(_tile('Seat', seat));
    }
    if (flight.notes.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(flight.notes),
        ),
      );
    }

    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Flight Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items,
      ),
    );
  }
}
