import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme/achievement_theme.dart';

/// Card displaying achievement progress.
class AchievementCard extends StatelessWidget {
  final AchievementTypeTheme theme;
  final String title;
  final int level;
  final int progress;
  final int maxProgress;

  const AchievementCard({
    super.key,
    required this.theme,
    required this.title,
    required this.level,
    required this.progress,
    required this.maxProgress,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxProgress == 0 ? 0.0 : progress / maxProgress;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(theme.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'LEVEL $level',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Semantics(
                    label: 'Progress: $progress of $maxProgress',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE0E0E0),
                        color: const Color(0xFFFFCC00),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Text('$progress/$maxProgress',
                style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
