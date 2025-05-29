import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/achievement.dart';
import 'app_dialog.dart';
import 'confetti.dart';

class AchievementDialog extends StatefulWidget {
  final Achievement achievement;
  const AchievementDialog({super.key, required this.achievement});

  @override
  State<AchievementDialog> createState() => _AchievementDialogState();
}

class _AchievementDialogState extends State<AchievementDialog>
    with TickerProviderStateMixin {
  late final AnimationController _iconController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();
  late final Animation<double> _iconAnimation =
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut);
  late final AnimationController _confettiController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  @override
  void dispose() {
    _iconController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialog = AppDialog(
      title: const Text('Achievement Unlocked!'),
      content: Row(
        children: [
          ScaleTransition(
            scale: _iconAnimation,
            child: widget.achievement.assetPath != null
                ? Image.asset(
                    widget.achievement.assetPath!,
                    width: 48,
                    height: 48,
                    semanticLabel: widget.achievement.title,
                  )
                : Icon(
                    widget.achievement.icon,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 48,
                    semanticLabel: widget.achievement.title,
                  ),
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
          onPressed: () => SharePlus.instance.share(
              'I just unlocked the "${widget.achievement.title}" achievement in SkyBook!'),
          child: const Text('Share'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        dialog,
        Positioned.fill(
          child: Confetti(
            controller: _confettiController,
            duration: const Duration(seconds: 2),
            key: const ValueKey('confetti'),
          ),
        ),
      ],
    );
  }
}
