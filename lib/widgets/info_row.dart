import 'package:flutter/material.dart';
import '../constants.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, color: Theme.of(context).colorScheme.primary));
      children.add(const SizedBox(width: 12));
    }
    children.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 2),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs + AppSpacing.xxs),
        child: Row(children: children),
      ),
    );
  }
}
