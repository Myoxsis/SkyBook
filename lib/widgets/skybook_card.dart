import 'package:flutter/material.dart';

import '../constants.dart';

/// Common card used throughout the app with consistent styling.
class SkyBookCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final double elevation;
  final double borderRadius;

  const SkyBookCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.elevation = 2,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.s),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: card);
    }
    return card;
  }
}
