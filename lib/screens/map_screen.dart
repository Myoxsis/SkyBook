import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

import '../utils/map_utils.dart';
import '../models/flight.dart';
import '../models/airport.dart';
import '../data/airport_data.dart';
import '../widgets/skybook_app_bar.dart';
import '../widgets/skybook_card.dart';
import '../constants.dart';

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
  final GlobalKey _shareKey = GlobalKey();
  bool _showTiles = false;

  double get _totalDuration {
    return _flights.fold(0.0, (prev, f) {
      final dur = double.tryParse(f.duration) ?? 0;
      return prev + dur;
    });
  }

  void _showAirportInfo(Airport airport) {
    final related = _flights
        .where((f) => f.origin == airport.code || f.destination == airport.code)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
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

  Future<File?> _captureMapImage() async {
    final boundary =
        _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    final bytes = byteData.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/map_share.png');
    await file.writeAsBytes(bytes);
    return file;
  }


  Future<void> _shareMap() async {
    setState(() => _showTiles = true);
    await Future.delayed(const Duration(milliseconds: 100));
    final file = await _captureMapImage();
    setState(() => _showTiles = false);
    if (file == null) return;
    await Share.shareXFiles(
      [XFile(file.path)],
      text:
          'Check out my flight map with ${_flights.length} flights totaling ${_totalDuration.toStringAsFixed(1)} hours using SkyBook!',
    );
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
          child: GestureDetector(
            onTap: () => _showAirportInfo(airport),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: const Icon(
                Icons.flight,
                size: 16,
                color: Colors.white,
                semanticLabel: 'Flight marker',
              ),
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
            points: MapUtils.arcPoints(start, end),
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
            icon: const Icon(Icons.share, semanticLabel: 'Share map'),
            onPressed: _shareMap,
          ),
          IconButton(
            icon:
                const Icon(Icons.settings, semanticLabel: 'Open settings'),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _shareKey,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: _zoom,
                onPositionChanged: (pos, _) {
                  _center = pos.center ?? _center;
                  _zoom = pos.zoom ?? _zoom;
                },
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag,
                ),
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
            if (_showTiles)
              Positioned(
                bottom: AppSpacing.s,
                left: AppSpacing.s,
                right: AppSpacing.s,
                child: Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.flight,
                        label: 'Total flights',
                        value: _flights.length.toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.schedule,
                        label: 'Total duration',
                        value: '${_totalDuration.toStringAsFixed(1)} h',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'mapZoomIn',
            onPressed: () {
              _controller.move(_center, _zoom + 1);
            },
            child: const Icon(Icons.add, semanticLabel: 'Zoom in'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'mapZoomOut',
            onPressed: () {
              _controller.move(_center, _zoom - 1);
            },
            child: const Icon(Icons.remove, semanticLabel: 'Zoom out'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: colors.primary, semanticLabel: label),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: colors.onSurface),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}
