import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/flight.dart';
import 'models/flight_storage.dart';
import 'models/theme_storage.dart';
import 'models/achievement.dart';
import 'models/achievement_storage.dart';
import 'utils/achievement_utils.dart';
import 'screens/home_screen.dart';
import 'widgets/achievement_dialog.dart';
import 'models/premium_storage.dart';

const Color _brandPrimary = Color(0xFF0A73B1);
const Color _brandSecondary = Color(0xFFEF6C00);

final ColorScheme _lightColorScheme =
    ColorScheme.fromSeed(seedColor: _brandPrimary, brightness: Brightness.light)
        .copyWith(secondary: _brandSecondary);

final ColorScheme _darkColorScheme =
    ColorScheme.fromSeed(seedColor: _brandPrimary, brightness: Brightness.dark)
        .copyWith(secondary: _brandSecondary);

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
  final ValueNotifier<bool> _premiumNotifier = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final Map<String, DateTime> _unlockedAchievements = {};

  void _updateAchievements() {
    final newAchievements =
        calculateAchievements(_flightsNotifier.value, _unlockedAchievements);
    for (final a in newAchievements) {
      if (a.achieved && !_unlockedAchievements.containsKey(a.id)) {
        final now = DateTime.now();
        _unlockedAchievements[a.id] = now;
        AchievementStorage.saveUnlocked(a.id, now);

        final context = _messengerKey.currentContext;
        if (context != null) {
          showDialog(
            context: context,
            builder: (_) => AchievementDialog(achievement: a),
          );
        }
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
    _loadAchievements().then((_) => _loadFlights());
    _loadTheme();
    _loadPremium();
  }

  Future<void> _loadFlights() async {
    final flights = await FlightStorage.loadFlights();
    final achievements = await AchievementStorage.loadUnlocked();
    _flightsNotifier.value = flights;
    _unlockedAchievements
      ..clear()
      ..addAll(achievements);
    _updateAchievements();
  }

  Future<void> _loadAchievements() async {
    final loaded = await AchievementStorage.loadUnlocked();
    _unlockedAchievements.addAll(loaded);
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

  Future<void> _loadPremium() async {
    final saved = await PremiumStorage.loadPremium();
    _premiumNotifier.value = saved;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      title: 'SkyBook',
      theme: ThemeData(
        colorScheme: _lightColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: _darkColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        darkMode: _darkMode,
        flightsNotifier: _flightsNotifier,
        premiumNotifier: _premiumNotifier,
        onFlightsChanged: _saveFlights,
        unlockedAchievements: _unlockedAchievements,
      ),
    );
  }
}
