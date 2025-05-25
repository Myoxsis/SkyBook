import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/achievement.dart';

class AchievementDialog extends StatefulWidget {
  final Achievement achievement;
  const AchievementDialog({super.key, required this.achievement});

  @override
  State<AchievementDialog> createState() => _AchievementDialogState();
}

class _AchievementDialogState extends State<AchievementDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Achievement Unlocked!'),
      content: Row(
        children: [
          ScaleTransition(
            scale: _animation,
            child: widget.achievement
                .buildIcon(color: Theme.of(context).colorScheme.secondary, size: 48),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.achievement.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Share.share(
              'I just unlocked the "${widget.achievement.title}" achievement in SkyBook!'),
          child: const Text('Share'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
