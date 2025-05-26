import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application text themes used for both light and dark modes.
class AppTextTheme {
  AppTextTheme._();

  static final TextTheme light = _buildTheme(ThemeData.light().textTheme);
  static final TextTheme dark = _buildTheme(ThemeData.dark().textTheme);

  static TextTheme _buildTheme(TextTheme base) {
    final textTheme = GoogleFonts.robotoTextTheme(base);
    return textTheme.copyWith(
      headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      headlineSmall: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      labelMedium: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
      labelSmall: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
