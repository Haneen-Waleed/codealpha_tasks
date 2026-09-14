import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/fitness_provider.dart';
import '../widgets/activity_tile.dart';
import '../widgets/empty_state.dart';
import 'activity_detail_screen.dart';
import 'add_edit_activity_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        child: Consumer<FitnessProvider>(
          builder: (context, provider, _) {
            if (provider.status == LoadStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.status == LoadStatus.error) {
              return Center(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Something went wrong',
                  message: provider.errorMessage ?? 'Please try again.',
                ),
              );
            }
            if (provider.activities.isEmpty) {
              return Center(
                child: EmptyState(
                  icon: Icons.history,
                  title: 'Nothing recorded yet',
                  message: 'Activities you log will show up here.',
                  action: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddEditActivityScreen(),
                        ),
                      );
                    },
                    child: const Text('Add Activity'),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: provider.activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final activity = provider.activities[index];
                return ActivityTile(
                  activity: activity,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ActivityDetailScreen(activity: activity),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
