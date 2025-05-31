import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

import '../utils/map_utils.dart';
import '../models/flight.dart';
import '../data/airport_data.dart';
import 'add_flight_screen.dart';
import '../widgets/skybook_app_bar.dart';
import '../widgets/info_row.dart';
import '../widgets/origin_destination_card.dart';
import '../constants.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/premium_badge.dart';
import '../utils/cached_tile_provider.dart';

class FlightDetailScreen extends StatelessWidget {
  final Flight flight;
  final ValueNotifier<bool> premiumNotifier;
  final List<Flight> flights;
  final GlobalKey _shareKey = GlobalKey();

  FlightDetailScreen({
    super.key,
    required this.flight,
    required this.premiumNotifier,
    required this.flights,
  });

  Future<void> _edit(BuildContext context) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => AddFlightScreen(
          flight: flight,
          flights: flights,
          premiumNotifier: premiumNotifier,
        ),
      ),
    );
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  Future<File?> _captureMapImage() async {
    final boundary =
        _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    final bytes = byteData.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/flight_share.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _share() async {
    final file = await _captureMapImage();
    final text = 'My flight from '
        '${flight.origin} to ${flight.destination} on ${flight.date} using SkyBook!';
    if (file != null) {
      await Share.shareXFiles([XFile(file.path)], text: text);
    } else {
      await Share.share(text);
    }
  }



  Widget _buildMap(BuildContext context) {
    final origin = airportByCode[flight.origin];
    final dest = airportByCode[flight.destination];
    if (origin == null || dest == null) return const SizedBox.shrink();

    final start = LatLng(origin.latitude, origin.longitude);
    final end = LatLng(dest.latitude, dest.longitude);
    final routePoints = MapUtils.arcPoints(start, end);
    final width = MediaQuery.of(context).size.width - AppSpacing.s * 2;
    const height = 200.0;
    final view = MapUtils.viewForPointsInSize(routePoints, width, height);
    final center = view.center;
    // Slightly zoom out so the takeoff and landing markers remain fully visible
    final zoom = (view.zoom - 0.3).clamp(0.0, 16.0);

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
          padding: const EdgeInsets.all(AppSpacing.xxs),
          child: const Icon(
            Icons.flight_takeoff,
            size: 16,
            color: Colors.white,
            semanticLabel: 'Origin',
          ),
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
          padding: const EdgeInsets.all(AppSpacing.xxs),
          child: const Icon(
            Icons.flight_land,
            size: 16,
            color: Colors.white,
            semanticLabel: 'Destination',
          ),
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
      child: RepaintBoundary(
        key: _shareKey,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
            minZoom: zoom,
            maxZoom: zoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
            ),
          ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.example.app',
            tileProvider: CachedTileProvider(),
          ),
          PolylineLayer(polylines: lines),
          MarkerLayer(markers: markers),
        ],
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      _buildMap(context),
      const SizedBox(height: 16),
      OriginDestinationCard(
        origin: flight.origin,
        destination: flight.destination,
      ),
      InfoRow(title: 'Date', value: flight.date, icon: Icons.calendar_today),
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
            if (!premium) {
              return const PremiumBadge(message: 'CO₂ data');
            }
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
    items.add(
      InfoRow(
        title: 'Trip Type',
        value: flight.isBusiness ? 'Business' : 'Personal',
        icon: Icons.work,
      ),
    );
    if (flight.notes.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
          child: Text(flight.notes),
        ),
      );
    }

    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Flight Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share, semanticLabel: 'Share flight'),
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.edit, semanticLabel: 'Edit flight'),
            onPressed: () => _edit(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s),
        children: items,
      ),
    );
  }
}
