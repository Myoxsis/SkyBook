import 'package:flutter/material.dart';
import 'models/flight.dart';
import 'models/flight_storage.dart';
import 'models/theme_storage.dart';
import 'models/achievement.dart';
import 'utils/achievement_utils.dart';
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
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final Set<String> _unlockedAchievements = {};

  void _updateAchievements() {
    final newAchievements = calculateAchievements(_flightsNotifier.value);
    for (final a in newAchievements) {
      if (a.achieved && !_unlockedAchievements.contains(a.id)) {
        _unlockedAchievements.add(a.id);
        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Achievement unlocked: ${a.title}')),
        );
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
    ThemeStorage.saveDarkMode(_darkMode);
  }

  @override
  void initState() {
    super.initState();
    _loadFlights();
    _loadTheme();
  }

  Future<void> _loadFlights() async {
    final flights = await FlightStorage.loadFlights();
    _flightsNotifier.value = flights;
    _updateAchievements();
  }

  Future<void> _saveFlights() async {
    await FlightStorage.saveFlights(_flightsNotifier.value);
    _updateAchievements();
  }

  Future<void> _loadTheme() async {
    final saved = await ThemeStorage.loadDarkMode();
    if (mounted) {
      setState(() {
        _darkMode = saved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      title: 'SkyBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
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
