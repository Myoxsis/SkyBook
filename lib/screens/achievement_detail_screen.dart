import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/achievement.dart';
import '../theme/achievement_theme.dart';
import '../constants.dart';
import 'package:intl/intl.dart' as intl;

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
                color: achievement.achieved
                    ? (theme?.color ??
                        Theme.of(context).colorScheme.primary)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
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
            if (achievement.unlockedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s),
                child: Text(
                  'Unlocked on '
                  '${intl.DateFormat.yMMMd().format(achievement.unlockedAt!)}',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: AppSpacing.m),
            Semantics(
              label:
                  'Progress: ${achievement.progress} of ${achievement.target}',
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: achievement.target == 0
                          ? 0
                          : achievement.progress / achievement.target,
                      minHeight: 6,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.12),
                      color: theme?.color ??
                          Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${achievement.progress}/${achievement.target}',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: achievement.achieved
                  ? () => Share.share(achievement.description)
                  : null,
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
