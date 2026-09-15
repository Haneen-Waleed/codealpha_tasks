import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/activity.dart';

IconData iconForWorkoutType(String type) {
  switch (type) {
    case 'Running':
      return Icons.directions_run;
    case 'Walking':
      return Icons.directions_walk;
    case 'Cycling':
      return Icons.directions_bike;
    case 'Strength Training':
      return Icons.fitness_center;
    case 'Yoga':
      return Icons.self_improvement;
    case 'Swimming':
      return Icons.pool;
    case 'HIIT':
      return Icons.bolt;
    default:
      return Icons.sports_gymnastics;
  }
}

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityTile({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d · h:mm a').format(activity.dateTime);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.neon.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconForWorkoutType(activity.type),
                color: AppColors.neon,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.type,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${activity.durationMinutes} min',
                  style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '${activity.caloriesBurned} kcal',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(width: 6),
             Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}