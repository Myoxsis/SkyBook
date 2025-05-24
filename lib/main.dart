import 'package:flutter/material.dart';
import 'models/flight.dart';
import 'models/flight_storage.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SkyBookApp());
}

class SkyBookApp extends StatefulWidget {
  const SkyBookApp({super.key});

  @override
  State<SkyBookApp> createState() => _SkyBookAppState();
}

class _SkyBookAppState extends State<SkyBookApp> {
  bool _darkMode = false;
  final ValueNotifier<List<Flight>> _flightsNotifier = ValueNotifier<List<Flight>>([]);

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final flights = await FlightStorage.loadFlights();
    _flightsNotifier.value = flights;
  }

  Future<void> _saveFlights() async {
    await FlightStorage.saveFlights(_flightsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        darkMode: _darkMode,
        flightsNotifier: _flightsNotifier,
        onFlightsChanged: _saveFlights,
      ),
    );
  }
}
