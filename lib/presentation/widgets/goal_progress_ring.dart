import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class GoalProgressRing extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String centerLabel;
  final String subLabel;

  const GoalProgressRing({
    super.key,
    required this.progress,
    required this.centerLabel,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clamped),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                backgroundColor: AppColors.surface2,
                valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.neon),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerLabel,
                style: AppTextStyles.title.copyWith(color: AppColors.white),
              ),
              Text(
                subLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}