import 'package:flutter/material.dart';
import 'colors.dart';
class AppFonts {
  static const String serif = 'Cormorant Garamond';
  static const String sans = 'Manrope';
}

class AppTextStyles {
  static  TextStyle title = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.text
  );

  static const TextStyle quote = TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 12,
  );
}