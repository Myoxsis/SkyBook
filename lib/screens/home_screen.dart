import 'package:flutter/material.dart';

import '../models/flight.dart';
import 'flight_screen.dart';
import 'map_screen.dart';
import 'status_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import '../widgets/skybook_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool darkMode;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final ValueNotifier<bool> premiumNotifier;
  final Future<void> Function() onFlightsChanged;
  final Map<String, DateTime> unlockedAchievements;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.darkMode,
    required this.flightsNotifier,
    required this.premiumNotifier,
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
          premiumNotifier: widget.premiumNotifier,
          flightsNotifier: widget.flightsNotifier,
          onFlightsChanged: widget.onFlightsChanged,
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
        premiumNotifier: widget.premiumNotifier,
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
        premiumNotifier: widget.premiumNotifier,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: SkyBookBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
