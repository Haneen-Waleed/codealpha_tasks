import 'dart:async';

import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../onboarding/screens/onboarding_screen.dart';
import '../../../features/register/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // Give the splash animation enough time to finish
    await Future.delayed(const Duration(milliseconds: 1800));

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(7, -7),
                  child: _buildCard(
                    color: primary.withOpacity(0.18),
                  ),
                ),

                Transform.translate(
                  offset: const Offset(3, -3),
                  child: _buildCard(
                    color: primary.withOpacity(0.35),
                  ),
                ),

                _buildCard(
                  color: primary,
                  child: const Icon(
                    Icons.style_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.easeOutBack,
            ),

            const SizedBox(height: 22),

            const Text(
              'FlashCards',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              ),
            )
                .animate()
                .fadeIn(
              delay: 350.ms,
              duration: 500.ms,
            )
                .slideY(
              begin: 0.15,
              end: 0,
              delay: 350.ms,
              duration: 500.ms,
            ),

            const SizedBox(height: 7),

            Text(
              'Learn one card at a time.',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            )
                .animate()
                .fadeIn(
              delay: 650.ms,
              duration: 500.ms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    Widget? child,
  }) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}