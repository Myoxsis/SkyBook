import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/achievement.dart';
import '../theme/achievement_theme.dart';
import '../constants.dart';

class AchievementDetailScreen extends StatelessWidget {
  final Achievement achievement;

  const AchievementDetailScreen({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final theme = achievementTypeThemes[achievement.category];
    return Scaffold(
      appBar: AppBar(
        title: Text(achievement.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: achievement.buildIcon(
                color: theme?.color ?? Theme.of(context).colorScheme.primary,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => Share.share(achievement.description),
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
