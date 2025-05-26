import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final String? assetPath;
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
    this.assetPath,
    required this.target,
    required this.progress,
    required this.achieved,
    this.unlockedAt,
    this.tier = 1,
  }) : assert(icon != null || assetPath != null,
            'Either icon or assetPath must be provided');

  Widget buildIcon({Color? color, double? size}) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: size,
        height: size,
        color: color,
        semanticLabel: title,
      );
    }
    return Icon(
      icon,
      color: color,
      size: size,
      semanticLabel: title,
    );
  }
}

