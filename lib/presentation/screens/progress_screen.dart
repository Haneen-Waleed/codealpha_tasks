import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../state/fitness_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';
import '../widgets/weekly_bar_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  Widget _weeklyStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.statValue),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.statLabel, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: Consumer<FitnessProvider>(
          builder: (context, provider, _) {
            if (provider.status == LoadStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.activities.isEmpty) {
              return Center(
                child: EmptyState(
                  icon: Icons.insights_outlined,
                  title: 'No progress yet',
                  message:
                      'Your weekly progress will appear here once you start tracking activities.',
                ),
              );
            }

            final days = provider.weeklyTotals;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                const Text('This Week', style: AppTextStyles.headline),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      _weeklyStat('${provider.weeklyTotalSteps}', 'Steps'),
                      _weeklyStat('${provider.weeklyTotalCalories}', 'Calories'),
                      _weeklyStat('${provider.weeklyTotalWorkouts}', 'Workouts'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                const SectionHeader(title: 'Steps per day'),
                const SizedBox(height: 12),
                WeeklyBarChart(
                  days: days,
                  valueSelector: (d) => d.steps,
                  unitLabel: 'steps',
                ),
                const SizedBox(height: 28),

                const SectionHeader(title: 'Calories burned per day'),
                const SizedBox(height: 12),
                WeeklyBarChart(
                  days: days,
                  valueSelector: (d) => d.calories,
                  unitLabel: 'kcal',
                ),
                const SizedBox(height: 28),

                const SectionHeader(title: 'Workout duration per day'),
                const SizedBox(height: 12),
                WeeklyBarChart(
                  days: days,
                  valueSelector: (d) => d.durationMinutes,
                  unitLabel: 'min',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
