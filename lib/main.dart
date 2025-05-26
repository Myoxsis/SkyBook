import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_actions/quick_actions.dart';
import 'models/flight.dart';
import 'models/flight_storage.dart';
import 'models/theme_storage.dart';
import 'models/achievement.dart';
import 'models/achievement_storage.dart';
import 'utils/achievement_utils.dart';
import 'screens/home_screen.dart';
import 'screens/add_flight_screen.dart';
import 'widgets/achievement_dialog.dart';
import 'models/premium_storage.dart';
import 'data/airport_data.dart';
import 'data/airline_data.dart';
import 'data/aircraft_data.dart';
import 'theme/colors.dart';

// Ensure text on the brand colors meets WCAG AA contrast ratio.
// Using white text on the primary blue yields a contrast of about 5.12:1.
// Using black text on the secondary orange yields a contrast of about 6.81:1.
final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  brightness: Brightness.light,
).copyWith(
  secondary: AppColors.secondary,
  tertiary: AppColors.accent,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onTertiary: Colors.white,
);

final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primaryDark,
  brightness: Brightness.dark,
).copyWith(
  secondary: AppColors.secondaryDark,
  tertiary: AppColors.accentDark,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onTertiary: Colors.black,
);

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
  final ValueNotifier<List<Flight>> _flightsNotifier =
      ValueNotifier<List<Flight>>([]);
  final ValueNotifier<bool> _premiumNotifier = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  final Map<String, DateTime> _unlockedAchievements = {};
  final QuickActions _quickActions = const QuickActions();

  void _showAchievementDialog(Achievement achievement) {
    final context = _navigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (_) => AchievementDialog(achievement: achievement),
      );
    }
  }

  void _updateAchievements() {
    final newAchievements =
        calculateAchievements(_flightsNotifier.value, _unlockedAchievements);
    for (final a in newAchievements) {
      if (a.achieved && !_unlockedAchievements.containsKey(a.id)) {
        final now = DateTime.now();
        _unlockedAchievements[a.id] = now;
        AchievementStorage.saveUnlocked(a.id, now);
        _showAchievementDialog(a);
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
    ThemeStorage.saveDarkMode(_darkMode);
  }

  void _setupQuickActions(bool premium) {
    if (premium) {
      _quickActions.setShortcutItems(const [
        ShortcutItem(type: 'add_flight', localizedTitle: 'Add Flight')
      ]);
    } else {
      _quickActions.clearShortcutItems();
    }
  }

  Future<void> _handleQuickAction(String? type) async {
    if (type == 'add_flight') {
      final newFlight = await _navigatorKey.currentState?.push<Flight>(
        MaterialPageRoute(
          builder: (_) => AddFlightScreen(flights: _flightsNotifier.value),
        ),
      );
      if (newFlight != null) {
        _flightsNotifier.value = List<Flight>.from(_flightsNotifier.value)
          ..add(newFlight);
        await _saveFlights();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _quickActions.initialize(_handleQuickAction);
    _premiumNotifier.addListener(() {
      _setupQuickActions(_premiumNotifier.value);
    });
    _loadReferenceData()
        .then((_) => _loadAchievements().then((_) => _loadFlights()));
    _loadTheme();
    _loadPremium();
  }

  Future<void> _loadReferenceData() async {
    await Future.wait([
      loadAirportData(),
      loadAirlineData(),
      loadAircraftData(),
    ]);
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
    _setupQuickActions(saved);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      navigatorKey: _navigatorKey,
      title: 'SkyBook',
      theme: ThemeData(
        colorScheme: _lightColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: _lightColorScheme.surfaceVariant,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: _darkColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: _darkColorScheme.surfaceVariant,
        ),
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
