import 'dart:async';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:random_quotes/core/helpers/helper.dart';
import 'package:random_quotes/features/main_screen.dart';
import '../../../core/theme/colors.dart';
import '../../onboarding/screens/onBoarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goNext();
  }

  Future<void> goNext() async {
    final y = await getBool();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        y ? const MainScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SafeArea(
        child: Stack(
          children: [
            // Text
            Padding(
              padding: EdgeInsets.only(left: 35.w, top: 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/star.png', width: 45.w),

                  SizedBox(height: 15.h),

                  Text(
                    'Good\nthings\ntake time',
                    style: AppTextStyles.header(),
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    'A little quote\nevery day, a little more\npeace in your mind',
                    style: AppTextStyles.quote(color: AppColors.grey),
                  ),
                ],
              ),
            ),

            // Flower
            Positioned(
              bottom: -10,
              right: -200,
              child: Image.asset('assets/images/flower.png'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> getBool() async {
  final x = await Helper().getOnboarding();
  return x ?? false;
}
