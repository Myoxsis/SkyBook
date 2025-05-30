import 'package:flutter/material.dart';

/// Bottom navigation bar used on the home screen.
class SkyBookBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SkyBookBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map, semanticLabel: 'Map'),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flight, semanticLabel: 'Flights'),
          label: 'Flights',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events, semanticLabel: 'Progress'),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics, semanticLabel: 'Status'),
          label: 'Status',
        ),
      ],
    );
  }
}
