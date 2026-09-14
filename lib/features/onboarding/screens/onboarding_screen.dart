import 'package:flutter/material.dart';
import 'package:random_quotes/core/custom_widgets/app_button.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:random_quotes/core/helpers/helper.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:random_quotes/features/main_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../models/onboarding_model.dart';
import '../widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: "assets/images/onboarding1.png",
      title: "A little\ninspiration ...",
      description: "can change your whole\nperspective",
    ),
    OnboardingModel(
      image: "assets/images/onboarding2.png",
      title: "Quotes for\nevery mood",
      description: "Motivation, peace, love,\nlife and more",
    ),
    OnboardingModel(
      image: "assets/images/Group26.png",
      title: "EMake it\nyour own",
      description:
          "Save your favourite,\nexplore categories,\nand find what speaks to you",
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void nextPage() async {
    if (currentIndex == onboardingData.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
      await Helper().setOnboarding(true);
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, top: 10.h),
                child: TextButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                    await Helper().setOnboarding(true);
                  },
                  child: Text(
                    "Skip",
                    style: AppTextStyles.body(color: AppColors.grey),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingItem(
                    image: onboardingData[index].image,
                    title: onboardingData[index].title,
                    description: onboardingData[index].description,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 10.h,
                  width: currentIndex == index ? 20.w : 10.w,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.text
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),

            SizedBox(height: 55.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: SizedBox(
                width: double.infinity,
                height: 55.h,
                child: AppButton(
                  isLoading: false,
                  text: currentIndex == onboardingData.length - 1
                      ? "Get Started"
                      : "Next",
                  onTap: nextPage,
                  color: currentIndex == onboardingData.length - 1
                      ? AppColors.text
                      : AppColors.peach,
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
