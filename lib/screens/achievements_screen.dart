import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/achievement.dart';
import '../utils/achievement_utils.dart';
import '../widgets/achievement_tile.dart';
import '../widgets/skybook_card.dart';
import '../theme/achievement_theme.dart';
import '../constants.dart';

/// Screen displaying user achievements.
class AchievementsScreen extends StatefulWidget {
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Map<String, DateTime> unlockedAchievements;

  const AchievementsScreen({
    super.key,
    required this.flightsNotifier,
    required this.unlockedAchievements,
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
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

  @override
  Widget build(BuildContext context) {
    final achievements =
        calculateAchievements(_flights, widget.unlockedAchievements);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s),
        children: [
          SkyBookCard(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                for (final a in achievements)
                  AchievementTile(
                    achievement: a,
                    theme: achievementTypeThemes[a.category] ??
                        const AchievementTypeTheme(
                          icon: Icons.emoji_events,
                          color: Colors.grey,
                          label: '',
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
