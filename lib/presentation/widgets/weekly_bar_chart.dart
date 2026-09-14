import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../state/fitness_provider.dart';

/// Simple, readable bar chart for the last 7 days. Deliberately avoids a
/// charting package — seven bars don't justify the dependency weight.
class WeeklyBarChart extends StatelessWidget {
  final List<DailyTotal> days;
  final int Function(DailyTotal) valueSelector;
  final String unitLabel;

  const WeeklyBarChart({
    super.key,
    required this.days,
    required this.valueSelector,
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final values = days.map(valueSelector).toList();
    final maxValue = values.fold<int>(0, (m, v) => v > m ? v : m);
    final today = DateTime.now();

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (i) {
          final day = days[i];
          final value = values[i];
          final heightFraction = maxValue == 0 ? 0.0 : value / maxValue;
          final isToday = day.date.year == today.year &&
              day.date.month == today.month &&
              day.date.day == today.day;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (value > 0)
                    Text(
                      value >= 1000
                          ? '${(value / 1000).toStringAsFixed(1)}k'
                          : '$value',
                      style: AppTextStyles.caption,
                    ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: heightFraction),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOut,
                      builder: (context, animatedFraction, _) => Container(
                        height: 96 * animatedFraction.clamp(0.02, 1.0),
                        width: double.infinity,
                        color: isToday
                            ? AppColors.deepTeal
                            : AppColors.deepTeal.withOpacity(0.35),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('E').format(day.date).substring(0, 1),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      color: isToday ? AppColors.deepTeal : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
