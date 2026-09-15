import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../state/fitness_provider.dart';

import '../widgets/stat_card.dart';
import '../widgets/goal_progress_ring.dart';
import '../widgets/empty_state.dart';
import '../widgets/activity_tile.dart';
import '../widgets/section_header.dart';

import 'add_edit_activity_screen.dart';
import 'activity_detail_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';

    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Consumer<FitnessProvider>(
          builder: (context, provider, _) {
            if (provider.status == LoadStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.neon,
                ),
              );
            }

            if (provider.status == LoadStatus.error) {
              return Center(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Something went wrong',
                  message:
                  provider.errorMessage ?? 'Please try again.',
                  action: OutlinedButton(
                    onPressed: () => provider.initialize(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neon,
                      side: const BorderSide(
                        color: AppColors.neon,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ),
              );
            }

            final hasAnyActivity =
                provider.activities.isNotEmpty;

            return RefreshIndicator(
              color: AppColors.neon,
              backgroundColor: AppColors.surface2,
              onRefresh: provider.initialize,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  110,
                ),
                children: [
                  // Greeting
                  Text(
                    _greeting(),
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'Today\'s Activity',
                    style: AppTextStyles.headline.copyWith(
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Daily Goal
                  Center(
                    child: GoalProgressRing(
                      progress: provider.overallDailyProgress,
                      centerLabel:
                      '${(provider.overallDailyProgress * 100).round()}%',
                      subLabel: 'of daily goal',
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Statistics
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: [
                      StatCard(
                        icon: Icons.directions_walk,
                        value: '${provider.todaySteps}',
                        label: 'Steps',
                      ),
                      StatCard(
                        icon:
                        Icons.local_fire_department_outlined,
                        value: '${provider.todayCalories}',
                        label: 'Calories burned',
                      ),
                      StatCard(
                        icon: Icons.timer_outlined,
                        value:
                        '${provider.todayDurationMinutes} min',
                        label: 'Workout time',
                      ),
                      StatCard(
                        icon: Icons.fitness_center,
                        value:
                        '${provider.todayWorkoutCount}',
                        label: 'Workouts',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Recent Activities
                  SectionHeader(
                    title: 'Recent Activities',
                    trailing: hasAnyActivity
                        ? TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                            const HistoryScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                        AppColors.neon,
                      ),
                      child: const Text('See all'),
                    )
                        : null,
                  ),

                  const SizedBox(height: 12),

                  if (!hasAnyActivity)
                    EmptyState(
                      icon: Icons.emoji_events_outlined,
                      title: 'Nothing recorded yet',
                      message:
                      'Start by adding your first workout to see your progress here.',
                    )
                  else
                    Column(
                      children: provider.recentActivities
                          .map(
                            (activity) => Padding(
                          padding:
                          const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: ActivityTile(
                            activity: activity,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ActivityDetailScreen(
                                        activity: activity,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                          .toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      // Add Activity
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
              const AddEditActivityScreen(),
            ),
          );
        },
        backgroundColor: AppColors.neon,
        foregroundColor: AppColors.bg,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Activity',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}