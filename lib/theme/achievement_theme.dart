import 'package:flutter/material.dart';
import 'colors.dart';

/// Theme data for an achievement type.
class AchievementTypeTheme {
  final IconData icon;
  final Color color;
  final String label;

  const AchievementTypeTheme({
    required this.icon,
    required this.color,
    required this.label,
  });
}

/// Mapping of achievement categories to theme data.
const Map<String, AchievementTypeTheme> achievementTypeThemes = {
  'Flights': AchievementTypeTheme(
    icon: Icons.flight_takeoff,
    color: AppColors.primary,
    label: 'Flights',
  ),
  'Distance': AchievementTypeTheme(
    icon: Icons.public,
    color: AppColors.accent,
    label: 'Distance',
  ),
  'Destinations': AchievementTypeTheme(
    icon: Icons.location_on,
    color: AppColors.secondary,
    label: 'Destinations',
  ),
};
