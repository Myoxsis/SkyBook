import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData? icon;
  final String? iconAsset;
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
    this.icon,
    this.iconAsset,
    required this.target,
    required this.progress,
    required this.achieved,
    this.unlockedAt,
    this.tier = 1,
  }) : assert(icon != null || iconAsset != null,
            'Either icon or iconAsset must be provided');

  Widget buildIcon({Color? color, double? size}) {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: size,
        height: size,
        color: color,
      );
    }
    return Icon(icon, color: color, size: size);
  }
}

