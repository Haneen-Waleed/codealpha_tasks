import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  Future<void> setOnboarding(bool answer) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setBool('onboarding', answer);
  }

  Future<bool?> getOnboarding() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final bool? x = sharedPreferences.getBool('onboarding');

    debugPrint('========== $x ==========');

    return x;
  }
}