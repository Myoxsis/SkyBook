import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/achievement.dart';
import '../theme/achievement_theme.dart';
import 'skybook_card.dart';

/// Small tile showing basic achievement progress.
class AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final AchievementTypeTheme theme;
  final VoidCallback? onTap;

  const AchievementTile({
    super.key,
    required this.achievement,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          achievement.buildIcon(
            color: achievement.achieved
                ? theme.color
                : colors.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '${achievement.progress}/${achievement.target}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: colors.onSurface),
            textAlign: TextAlign.center,
          ),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
