import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../widgets/flight_tile.dart';
import 'add_flight_screen.dart';
import 'flight_detail_screen.dart';
import '../widgets/skybook_app_bar.dart';

class FlightScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final ValueNotifier<bool> premiumNotifier;
  final Future<void> Function() onFlightsChanged;

  const FlightScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
    required this.premiumNotifier,
    required this.onFlightsChanged,
  });

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

enum _FlightSortOrder { newestFirst, oldestFirst }

class _FlightScreenState extends State<FlightScreen> {
  List<Flight> _allFlights = [];
  List<Flight> _flights = [];
  List<int> _availableYears = [];
  int? _yearFilter;
  late VoidCallback _listener;
  _FlightSortOrder _sortOrder = _FlightSortOrder.newestFirst;

  void _sortList(List<Flight> list) {
    list.sort((a, b) {
      final da = DateTime.tryParse(a.date);
      final db = DateTime.tryParse(b.date);
      if (da == null || db == null) return 0;
      return _sortOrder == _FlightSortOrder.newestFirst
          ? db.compareTo(da)
          : da.compareTo(db);
    });
  }

  void _sortFlights() => _sortList(_flights);
  void _sortAllFlights() => _sortList(_allFlights);

  void _updateYears() {
    _availableYears = _allFlights
        .map((f) => DateTime.tryParse(f.date)?.year)
        .whereType<int>()
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
  }

  void _applyFilters() {
    _flights = _allFlights.where((f) {
      if (_yearFilter != null) {
        final year = DateTime.tryParse(f.date)?.year;
        return year == _yearFilter;
      }
      return true;
    }).toList();
    _sortFlights();
  }

  Widget _buildYearMenu() {
    return PopupMenuButton<int?>(
      icon: const Icon(Icons.filter_alt, semanticLabel: 'Filter by year'),
      tooltip: 'Filter by year',
      onSelected: (year) {
        setState(() {
          _yearFilter = year;
          _applyFilters();
        });
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<int?>>[];
        items.add(
          PopupMenuItem<int?>(
            value: null,
            child: Row(
              children: [
                if (_yearFilter == null) ...[
                  const Icon(Icons.check, size: 16, semanticLabel: 'Selected'),
                  const SizedBox(width: 8),
                ],
                const Text('All'),
              ],
            ),
          ),
        );
        for (final y in _availableYears) {
          items.add(
            PopupMenuItem<int?>(
              value: y,
              child: Row(
                children: [
                  if (_yearFilter == y) ...[
                    const Icon(Icons.check, size: 16, semanticLabel: 'Selected'),
                    const SizedBox(width: 8),
                  ],
                  Text(y.toString()),
                ],
              ),
            ),
          );
        }
        return items;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _allFlights = List<Flight>.from(widget.flightsNotifier.value);
    _sortAllFlights();
    _updateYears();
    _applyFilters();
    _listener = () {
      setState(() {
        _allFlights = List<Flight>.from(widget.flightsNotifier.value);
        _sortAllFlights();
        _updateYears();
        _applyFilters();
      });
    };
    widget.flightsNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    widget.flightsNotifier.removeListener(_listener);
    super.dispose();
  }

  Future<void> _addFlight() async {
    final newFlight = await Navigator.of(context).push<Flight>(
      MaterialPageRoute(
          builder: (_) => AddFlightScreen(flights: _allFlights)),
    );
    if (newFlight != null) {
      _allFlights = List<Flight>.from(_allFlights)..add(newFlight);
      _sortAllFlights();
      _updateYears();
      _applyFilters();
      widget.flightsNotifier.value = List<Flight>.from(_allFlights);
      await widget.onFlightsChanged();
    }
  }


  void _toggleFavorite(int index) {
    final flight = _flights[index];
    final updated = flight.copyWith(isFavorite: !flight.isFavorite);
    _flights[index] = updated;
    final allIndex = _allFlights.indexWhere((f) => f.id == flight.id);
    if (allIndex != -1) _allFlights[allIndex] = updated;
    widget.flightsNotifier.value = List<Flight>.from(_allFlights);
    widget.onFlightsChanged();
  }

  Future<void> _viewFlight(int index) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => FlightDetailScreen(
          flight: _flights[index],
          premiumNotifier: widget.premiumNotifier,
          flights: _allFlights,
        ),
      ),
    );
    if (result is Flight) {
      final originalId = _flights[index].id;
      _flights[index] = result;
      final allIndex =
          _allFlights.indexWhere((f) => f.id == originalId);
      if (allIndex != -1) _allFlights[allIndex] = result;
      _sortAllFlights();
      _updateYears();
      _applyFilters();
      widget.flightsNotifier.value = List<Flight>.from(_allFlights);
      await widget.onFlightsChanged();
    } else if (result == 'delete') {
      final originalId = _flights[index].id;
      _flights = List<Flight>.from(_flights)..removeAt(index);
      _allFlights.removeWhere((f) => f.id == originalId);
      _updateYears();
      _applyFilters();
      widget.flightsNotifier.value = List<Flight>.from(_allFlights);
      await widget.onFlightsChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Flights',
        actions: [
          _buildYearMenu(),
          PopupMenuButton<_FlightSortOrder>(
            icon: const Icon(Icons.sort, semanticLabel: 'Sort'),
            onSelected: (order) {
              setState(() {
                _sortOrder = order;
                _sortAllFlights();
                _applyFilters();
              });
              widget.flightsNotifier.value = List<Flight>.from(_allFlights);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _FlightSortOrder.newestFirst,
                child: Text('Most Recent'),
              ),
              PopupMenuItem(
                value: _FlightSortOrder.oldestFirst,
                child: Text('Oldest'),
              ),
            ],
          ),
          IconButton(
            icon:
                const Icon(Icons.settings, semanticLabel: 'Open settings'),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlight,
        child: const Icon(Icons.add, semanticLabel: 'Add flight'),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          return FlightTile(
            flight: _flights[index],
            onToggleFavorite: () => _toggleFavorite(index),
            onTap: () => _viewFlight(index),
          );
        },
      ),
    );
  }
}
