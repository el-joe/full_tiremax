import 'package:flutter/material.dart';

/// Design tokens mirrored 1:1 from the Next.js frontend
/// (frontend/app/[locale]/globals.css, frontend/theme/tokens/*.ts).
class AppColors {
  AppColors._();

  /// Brand yellow.
  static const Color primary = Color(0xFFFDB604);

  /// App is dark-first; this is the default background.
  static const Color background = Color(0xFF0E0E0E);

  /// Foreground text on dark surfaces.
  static const Color foregroundDark = Color(0xFFFFFFFF);

  /// Foreground text on light surfaces.
  static const Color foregroundLight = Color(0xFF18181B);

  /// Secondary / error red.
  static const Color error = Color(0xFFEE0F0F);

  /// Destructive text red.
  static const Color red = Color(0xFFAE1819);

  /// Border / divider gray.
  static const Color gray = Color(0xFFE8E8E8);

  /// Muted text gray.
  static const Color gray2 = Color(0xFF71717A);

  /// Dark gray surface.
  static const Color gray3 = Color(0xFF333333);

  /// Light surface gray.
  static const Color gray4 = Color(0xFFF3F3F3);

  /// Info blue.
  static const Color blue = Color(0xFF1976D2);

  /// Success green.
  static const Color green = Color(0xFF2E7D32);

  /// On-primary text (dark yellow), used for text/icons placed on top of
  /// [primary]-colored surfaces.
  static const Color onPrimary = Color(0xFF6B4C00);
}
