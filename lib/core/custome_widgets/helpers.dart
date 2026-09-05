import 'dart:ui';

import 'package:flutter/material.dart';

class Helpers {
  Future<void> snackBar(context,{required String text,required Color color}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}