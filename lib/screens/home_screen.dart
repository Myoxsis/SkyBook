import 'package:flutter/material.dart';

import '../models/flight.dart';
import 'flight_screen.dart';
import 'map_screen.dart';
import 'status_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool darkMode;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Future<void> Function() onFlightsChanged;
  final Map<String, DateTime> unlockedAchievements;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.darkMode,
    required this.flightsNotifier,
    required this.onFlightsChanged,
    required this.unlockedAchievements,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Key _flightScreenKey = UniqueKey();
  Key _statusScreenKey = UniqueKey();
  Key _progressScreenKey = UniqueKey();

  void _handleDataCleared() {
    setState(() {
      _flightScreenKey = UniqueKey();
      _statusScreenKey = UniqueKey();
      _progressScreenKey = UniqueKey();
      widget.flightsNotifier.value = [];
      widget.unlockedAchievements.clear();
    });
    widget.onFlightsChanged();
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          darkMode: widget.darkMode,
          onToggleTheme: widget.onToggleTheme,
          onClearData: _handleDataCleared,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MapScreen(
        key: const PageStorageKey('map'),
        onOpenSettings: _openSettings,
        flightsNotifier: widget.flightsNotifier,
      ),
      FlightScreen(
        key: _flightScreenKey,
        onOpenSettings: _openSettings,
        flightsNotifier: widget.flightsNotifier,
        onFlightsChanged: widget.onFlightsChanged,
      ),
      ProgressScreen(
        key: _progressScreenKey,
        onOpenSettings: _openSettings,
        flightsNotifier: widget.flightsNotifier,
        unlockedAchievements: widget.unlockedAchievements,
      ),
      StatusScreen(
        key: _statusScreenKey,
        onOpenSettings: _openSettings,
        flightsNotifier: widget.flightsNotifier,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            // icon: ImageIcon(const AssetImage('assets/icons/map.png')),
            icon: const Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(const AssetImage('assets/icons/flights.png')),
            icon: const Icon(Icons.flight),
            label: 'Flights',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(const AssetImage('assets/icons/progress.png')),
            icon: const Icon(Icons.emoji_events),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            // icon: ImageIcon(const AssetImage('assets/icons/status.png')),
            icon: const Icon(Icons.analytics),
            label: 'Status',
          ),
        ],
      ),
    );
  }
}
