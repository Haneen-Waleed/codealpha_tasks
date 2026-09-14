import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import '../../../core/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuoteCardSkeleton extends StatelessWidget {
  const QuoteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Skeletonizer(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.format_quote_rounded),
                    Icon(Icons.favorite_border),
                  ],
                ),

                SizedBox(height: 25.h),

                Text(
                  'A beautiful quote that takes some space',
                  style: AppTextStyles.normal(),
                ),

                SizedBox(height: 10.h),

                Text(
                  'Another line of the quote',
                  style: AppTextStyles.normal(),
                ),

                SizedBox(height: 25.h),

                Text('_Unknown Author', style: AppTextStyles.normal()),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
