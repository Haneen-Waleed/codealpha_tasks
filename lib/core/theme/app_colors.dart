import 'package:flutter/material.dart';

/// Central palette. Use these names, not raw hex codes, everywhere else
/// in the app so the palette stays easy to audit and restrained.
class AppColors {
  AppColors._();

  static const Color inkBlack = Color(0xFF011C27);
  static const Color bananaCream = Color(0xFFFFF07C);
  static const Color deepTeal = Color(0xFF4E6E5D);
  static const Color lavender = Color(0xFFE9EBF8);
  static const Color mauveShadow = Color(0xFF563440);

  // Supporting neutrals for contrast/readability. Not part of the brand
  // five, used only where pure brand colors would fail accessibility.
  static const Color offWhite = Color(0xFFFBFBFD);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFC9CDD6);
  static const Color midGray = Color(0xFF7C8590);
  static const Color errorRed = Color(0xFFB3261E);

  // Semantic aliases so screens read intent, not raw color names.
  static const Color background = lavender;
  static const Color surface = surfaceWhite;
  static const Color primaryAction = deepTeal;
  static const Color primaryText = inkBlack;
  static const Color secondaryText = midGray;
  static const Color highlight = bananaCream;
  static const Color secondaryAccent = mauveShadow;
  static const Color divider = lightGray;
}
