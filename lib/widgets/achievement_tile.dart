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
          Semantics(
            label: 'Progress: ${achievement.progress} of ${achievement.target}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: achievement.target == 0
                    ? 0
                    : achievement.progress / achievement.target,
                minHeight: 6,
                backgroundColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                color: theme.color,
              ),
            ),
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
