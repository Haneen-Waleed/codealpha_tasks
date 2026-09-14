import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OnboardingItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, height: 200.h),

          SizedBox(height: 50.h),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.quote(),
          ),

          SizedBox(height: 26.h),

          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.normal(),
          ),
        ],
      ),
    );
  }
}
