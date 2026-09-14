import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'colors.dart';

class AppFonts {
  static const String serif = 'Cormorant Garamond';
  static const String sans = 'Manrope';
}

class AppTextStyles {
  static TextStyle title({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.serif,
      fontSize: 25.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle quote({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.serif,
      fontSize: 21.sp,
      fontWeight: FontWeight.w500,
      height: 1.3.h,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle body({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.sans,
      fontSize: 14.sp,
      height: 1.5.h,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle button({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.sans,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle caption({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.sans,
      fontSize: 12.sp,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle normal({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.serif,
      fontSize: 14.sp,
      color: color ?? AppColors.text,
    );
  }

  static TextStyle header({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.serif,
      fontSize: 35.sp,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.text,
    );
  }
}
