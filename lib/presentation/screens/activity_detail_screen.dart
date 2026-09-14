import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/activity.dart';
import '../../state/fitness_provider.dart';
import '../widgets/activity_tile.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'add_edit_activity_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMuted),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
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
            icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
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
                SnackBar(content: Text(feedback ?? 'Done.')),
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.lavender,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconForWorkoutType(activity.type),
                      color: AppColors.deepTeal,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(activity.type, style: AppTextStyles.title),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _row('Date', DateFormat('EEEE, MMM d, yyyy').format(activity.dateTime)),
                  const Divider(),
                  _row('Time', DateFormat('h:mm a').format(activity.dateTime)),
                  const Divider(),
                  _row('Duration', '${activity.durationMinutes} minutes'),
                  const Divider(),
                  _row('Calories burned', '${activity.caloriesBurned} kcal'),
                  if (activity.steps > 0) ...[
                    const Divider(),
                    _row('Steps', '${activity.steps}'),
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
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notes', style: AppTextStyles.statLabel),
                    const SizedBox(height: 6),
                    Text(activity.notes!, style: AppTextStyles.body),
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
