import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skybook/screens/achievement_detail_screen.dart';
import 'package:skybook/models/achievement.dart';
import 'package:intl/intl.dart' as intl;

void main() {
  testWidgets('share disabled when achievement locked', (tester) async {
    const achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: 'desc',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 0,
      achieved: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDetailScreen(achievement: achievement),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('share enabled when achievement unlocked', (tester) async {
    const achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: 'desc',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 1,
      achieved: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDetailScreen(achievement: achievement),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('shows unlocked date when available', (tester) async {
    final date = DateTime(2024, 1, 1);
    final achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: 'desc',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 1,
      achieved: true,
      unlockedAt: date,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDetailScreen(achievement: achievement),
        ),
      ),
    );

    final expected = 'Unlocked on '
        '${intl.DateFormat.yMMMd().format(date)}';
    expect(find.text(expected), findsOneWidget);
  });

  testWidgets('icon grey when achievement locked', (tester) async {
    const achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: 'desc',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 0,
      achieved: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDetailScreen(achievement: achievement),
        ),
      ),
    );

    final context = tester.element(find.byType(AchievementDetailScreen));
    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(icon.color, Theme.of(context).colorScheme.onSurfaceVariant);
  });

  testWidgets('icon colored when achievement unlocked', (tester) async {
    const achievement = Achievement(
      id: 'test',
      title: 'Test',
      description: 'desc',
      category: 'Test',
      icon: Icons.star,
      target: 1,
      progress: 1,
      achieved: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDetailScreen(achievement: achievement),
        ),
      ),
    );

    final context = tester.element(find.byType(AchievementDetailScreen));
    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(icon.color, Theme.of(context).colorScheme.primary);
  });
}
