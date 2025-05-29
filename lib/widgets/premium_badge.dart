import 'package:flutter/material.dart';
import '../constants.dart';
import 'skybook_card.dart';
import 'app_dialog.dart';

/// Badge shown in place of premium-only content.
class PremiumBadge extends StatelessWidget {
  final String message;

  const PremiumBadge({super.key, required this.message});

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AppDialog(
        title: Text('Premium Feature'),
        content: Text(
          'Unlock premium to access CO₂ data, detailed charts and '
          'home screen shortcuts.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SkyBookCard(
      onTap: () => _showInfo(context),
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, color: colors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
