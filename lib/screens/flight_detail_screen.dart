import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../utils/map_utils.dart';
import '../models/flight.dart';
import '../data/airport_data.dart';
import 'add_flight_screen.dart';
import '../widgets/skybook_app_bar.dart';
import '../widgets/info_row.dart';
import 'package:share_plus/share_plus.dart';

class FlightDetailScreen extends StatelessWidget {
  final Flight flight;
  final ValueNotifier<bool> premiumNotifier;

  const FlightDetailScreen({
    super.key,
    required this.flight,
    required this.premiumNotifier,
  });

  Future<void> _edit(BuildContext context) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => AddFlightScreen(flight: flight)),
    );
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  void _share() {
    final text = 'My flight from '
        '${flight.origin} to ${flight.destination} on ${flight.date} using SkyBook!';
    Share.share(text);
  }



  Widget _buildMap(BuildContext context) {
    final origin = airportByCode[flight.origin];
    final dest = airportByCode[flight.destination];
    if (origin == null || dest == null) return const SizedBox.shrink();

    final start = LatLng(origin.latitude, origin.longitude);
    final end = LatLng(dest.latitude, dest.longitude);
    final routePoints = MapUtils.arcPoints(start, end);
    final view = MapUtils.viewForPoints(routePoints);
    final center = view.center;
    final zoom = view.zoom;

    final markers = [
      Marker(
        point: start,
        width: 30,
        height: 30,
        child: Container(
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
        child: Container(
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
        points: routePoints,
        color: Theme.of(context).colorScheme.secondary,
        strokeWidth: 3,
      )
    ];

    return SizedBox(
      height: 200,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
            minZoom: zoom,
            maxZoom: zoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag,
            ),
          ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
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
      InfoRow(title: 'Date', value: flight.date, icon: Icons.calendar_today),
      Row(
        children: [
          Expanded(
            child: InfoRow(
              title: 'From',
              value: flight.origin,
              icon: Icons.flight_takeoff,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InfoRow(
              title: 'To',
              value: flight.destination,
              icon: Icons.flight_land,
            ),
          ),
        ],
      ),
      InfoRow(title: 'Aircraft', value: flight.aircraft, icon: Icons.flight),
    ];

    if (flight.airline.isNotEmpty) {
      items.add(InfoRow(title: 'Airline', value: flight.airline, icon: Icons.airlines));
    }
    if (flight.callsign.isNotEmpty) {
      items.add(InfoRow(title: 'Flight No.', value: flight.callsign, icon: Icons.confirmation_number));
    }
    if (flight.duration.isNotEmpty) {
      items.add(InfoRow(title: 'Duration', value: '${flight.duration}h', icon: Icons.schedule));
    }
    if (flight.distanceKm > 0) {
      items.add(InfoRow(title: 'Distance', value: '${flight.distanceKm.round()} km', icon: Icons.straighten));
    }
    if (flight.carbonKg > 0) {
      items.add(
        ValueListenableBuilder<bool>(
          valueListenable: premiumNotifier,
          builder: (context, premium, _) {
            if (!premium) return const SizedBox.shrink();
            return InfoRow(
              title: 'CO₂ per passenger',
              value: '${flight.carbonKg.round()} kg',
              icon: Icons.cloud,
            );
          },
        ),
      );
    }
    if (flight.travelClass.isNotEmpty) {
      items.add(InfoRow(title: 'Class', value: flight.travelClass, icon: Icons.chair));
    }
    if (flight.seatNumber.isNotEmpty || flight.seatLocation.isNotEmpty) {
      final seat = [flight.seatNumber, flight.seatLocation].where((e) => e.isNotEmpty).join(' ');
      items.add(InfoRow(title: 'Seat', value: seat, icon: Icons.event_seat));
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
            icon: const Icon(Icons.share),
            onPressed: _share,
          ),
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
