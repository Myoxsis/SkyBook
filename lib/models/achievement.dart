import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final int target;
  final int progress;
  final bool achieved;
  final DateTime? unlockedAt;
  final int tier;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.target,
    required this.progress,
    required this.achieved,
    this.unlockedAt,
    this.tier = 1,
  });
}

