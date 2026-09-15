import 'package:flutter/material.dart';
class AppColors {
  AppColors._();

  /// State flag updated by [ThemeProvider] when toggled.
  static bool isDark = true;

  static const Color neon = Color(0xFFFBA912);
  static const Color neonLight = Color(0xFFFFC44D);
  static const Color neonDark = Color(0xFFD88900);

  static const Color success = Color(0xFF35D07F);
  static const Color error = Color(0xFFFF4D4D);
  static const Color info = Color(0xFF4DA6FF);

  static Color get bg =>
      isDark ? const Color(0xFF141414) : const Color(0xFFF5F5F7);

  static Color get surface2 =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5EA);

  static Color get card =>
      isDark ? const Color(0xFF242424) : const Color(0xFFFFFFFF);

  static Color get white =>
      isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1C1C1E);

  static Color get textSecondary =>
      isDark ? const Color(0xFFA6A6A6) : const Color(0xFF6E6E73);

  static Color get textMuted =>
      isDark ? const Color(0xFF6F6F6F) : const Color(0xFFA1A1A6);

  static Color get border =>
      isDark ? const Color(0xFF333333) : const Color(0xFFE5E5EA);
}