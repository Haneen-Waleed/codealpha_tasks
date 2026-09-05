import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/features/register/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<_OnboardingData> pages = [
    _OnboardingData(
      title: 'Learn your way.',
      description:
      'Create your own flashcards and turn anything you learn into something easy to remember.',
      icon: Icons.style_outlined,
    ),
    _OnboardingData(
      title: 'Keep it organized.',
      description:
      'Put your cards into folders and keep every subject exactly where you need it.',
      icon: Icons.folder_open_outlined,
    ),
    _OnboardingData(
      title: 'Test yourself.',
      description:
      'Review your cards and challenge yourself with quick quizzes whenever you want.',
      icon: Icons.quiz_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isFirstLaunch',
      false,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  void _nextPage() {
    if (currentPage == pages.length - 1) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = pages[currentPage];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                  right: 20,
                ),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = pages[index];

                  return _buildPage(item);
                },
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: primary,
                dotColor: Colors.grey.shade300,
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
                spacing: 6,
              ),
            ),

            const SizedBox(height: 28),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                28,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildVisual(data.icon)
              .animate(
            key: ValueKey(data.title),
          )
              .fadeIn(
            duration: 450.ms,
          )
              .slideY(
            begin: 0.12,
            end: 0,
            duration: 450.ms,
            curve: Curves.easeOut,
          ),

          const SizedBox(height: 55),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          )
              .animate(
            key: ValueKey('${data.title}-title'),
          )
              .fadeIn(
            delay: 150.ms,
            duration: 400.ms,
          ),

          const SizedBox(height: 14),

          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: grey,
              fontSize: 15,
              height: 1.55,
            ),
          )
              .animate(
            key: ValueKey('${data.title}-description'),
          )
              .fadeIn(
            delay: 250.ms,
            duration: 400.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(IconData icon) {
    return SizedBox(
      width: 210,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 15,
            right: 20,
            child: Transform.rotate(
              angle: 0.10,
              child: _visualCard(
                color: primary.withOpacity(0.10),
              ),
            ),
          ),

          Positioned(
            bottom: 10,
            left: 18,
            child: Transform.rotate(
              angle: -0.08,
              child: _visualCard(
                color: primary.withOpacity(0.18),
              ),
            ),
          ),

          _visualCard(
            color: primary,
            child: Icon(
              icon,
              color: background,
              size: 46,
            ),
          ),
        ],
      ),
    );
  }

  Widget _visualCard({
    required Color color,
    Widget? child,
  }) {
    return Container(
      width: 135,
      height: 155,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: child,
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}