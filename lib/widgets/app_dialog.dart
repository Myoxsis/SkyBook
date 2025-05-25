import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const AppDialog({super.key, this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surfaceVariant,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: theme.textTheme.bodyMedium,
    );
  }
}
