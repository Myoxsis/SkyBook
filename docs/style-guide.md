# SkyBook Style Guide

This document summarizes the core design tokens used throughout the app. Refer to these values when implementing new UI components.

## Color Tokens

The color palette is defined in `lib/theme/colors.dart`.

| Token | Light | Dark | Description |
|-------|-------|------|-------------|
| `primary` | `0xFF58CC02` | `primaryDark` | Bright green used for major actions. |
| `secondary` | `0xFFFFC107` | `secondaryDark` | Yellow accent for highlights and buttons. |
| `accent` | `0xFF34A853` | `accentDark` | Deeper green used sparingly for emphasis. |

Use `primaryLight`, `secondaryLight`, and `accentLight` for subtle variants.

## Spacing Scale

Spacing follows an 8‑point grid defined in `lib/constants.dart`.

| Token | Value (dp) |
|-------|------------|
| `xxs` | 4 |
| `xs`  | 8 |
| `s`   | 16 |
| `m`   | 24 |
| `l`   | 32 |
| `xl`  | 40 |
| `xxl` | 48 |

These tokens are used for padding and layout gaps to keep the interface consistent.

## Typography

Font styles are created in `lib/theme/text_theme.dart` using the Nunito font via Google Fonts. The bold and semi‑bold weights are applied to headings and titles to maintain hierarchy.

When creating new text styles, start from `AppTextTheme.light` or `AppTextTheme.dark` to ensure proper scaling and accessibility.

---

See the Figma file for component specifications including the app bar, card styles and navigation bar. Keep this guide up to date as colors or typography evolve.
