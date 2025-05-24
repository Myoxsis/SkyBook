import 'package:flutter/material.dart';

import 'flight_screen.dart';
import 'status_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool darkMode;
  const HomeScreen({super.key, required this.onToggleTheme, required this.darkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Key _flightScreenKey = UniqueKey();
  Key _statusScreenKey = UniqueKey();

  void _handleDataCleared() {
    setState(() {
      _flightScreenKey = UniqueKey();
      _statusScreenKey = UniqueKey();
    });
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
      FlightScreen(onOpenSettings: _openSettings),
      ProgressScreen(onOpenSettings: _openSettings),
      StatusScreen(onOpenSettings: _openSettings),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Flights'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Status'),
        ],
      ),
    );
  }
}
