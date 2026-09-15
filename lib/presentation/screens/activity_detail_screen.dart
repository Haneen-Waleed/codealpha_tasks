import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/models/activity.dart';
import '../../state/fitness_provider.dart';
import '../widgets/activity_tile.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'add_edit_activity_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();

    Widget buildRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
            ),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Activity Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.white),
            tooltip: 'Edit',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddEditActivityScreen(existingActivity: activity),
                ),
              );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Delete',
            onPressed: () async {
              final confirmed = await showConfirmDeleteDialog(
                context,
                itemLabel: activity.type,
              );
              if (confirmed != true || !context.mounted) return;

              final provider = context.read<FitnessProvider>();
              final success = await provider.removeActivity(activity.id!);
              final feedback = provider.consumeFeedback();

              if (!context.mounted) return;
              if (success) Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.card,
                  content: Text(
                    feedback ?? 'Done.',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.neon.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconForWorkoutType(activity.type),
                      color: AppColors.neon,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      activity.type,
                      style: AppTextStyles.title.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  buildRow('Date', DateFormat('EEEE, MMM d, yyyy').format(activity.dateTime)),
                  Divider(color: AppColors.border),
                  buildRow('Time', DateFormat('h:mm a').format(activity.dateTime)),
                  Divider(color: AppColors.border),
                  buildRow('Duration', '${activity.durationMinutes} minutes'),
                  Divider(color: AppColors.border),
                  buildRow('Calories burned', '${activity.caloriesBurned} kcal'),
                  if (activity.steps > 0) ...[
                    Divider(color: AppColors.border),
                    buildRow('Steps', '${activity.steps}'),
                  ],
                ],
              ),
            ),
            if (activity.notes != null && activity.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: AppTextStyles.statLabel.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activity.notes!,
                      style: AppTextStyles.body.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}