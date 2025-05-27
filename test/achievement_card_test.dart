import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skybook/widgets/achievement_card.dart';
import 'package:skybook/theme/achievement_theme.dart';

void main() {
  testWidgets('achievement card displays level and progress text', (tester) async {
    const theme = AchievementTypeTheme(
      icon: Icons.star,
      color: Colors.blue,
      label: 'Test',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AchievementCard(
            theme: theme,
            title: 'Test',
            level: 2,
            progress: 3,
            maxProgress: 10,
          ),
        ),
      ),
    );

    expect(find.text('LEVEL 2'), findsOneWidget);
    expect(find.text('3/10'), findsOneWidget);
  });
}
