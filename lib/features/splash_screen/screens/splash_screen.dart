import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:random_quotes/core/helpers/helper.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:random_quotes/features/main_screen.dart';
import '../../onboarding/screens/onBoarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    goNext();
  }

  Future<void> goNext() async {
    final y = await getBool();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) =>
        y ? const MainScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Star
                  Container(
                    width: 82.w,
                    height: 82.w,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/star.png',
                        width: 42.w,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // App name
                  Text(
                    'Random Quotes',
                    style: AppTextStyles.header(),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10.h),

                  // Small tagline
                  Text(
                    'A little quote,\na little peace.',
                    style: AppTextStyles.quote(
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 55.h),

                  // Minimal loading indicator
                  SizedBox(
                    width: 35.w,
                    child: LinearProgressIndicator(
                      minHeight: 2.h,
                      backgroundColor: AppColors.white.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> getBool() async {
  final x = await Helper().getOnboarding();
  return x ?? false;
}