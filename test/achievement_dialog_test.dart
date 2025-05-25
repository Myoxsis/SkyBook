import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skybook/widgets/achievement_dialog.dart';
import 'package:skybook/models/achievement.dart';

void main() {
  testWidgets('achievement dialog displays provided icon', (tester) async {
    const achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: '',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 1,
      achieved: true,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: achievement),
        ),
      ),
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
