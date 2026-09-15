import 'dart:developer' as developer;
import '../database/database_helper.dart';
import '../models/activity.dart';

/// repository call succeeded so no exceptions leak up to the UI
class RepositoryResult<T> {
  final T? data;
  final String? error;
  const RepositoryResult.success(this.data) : error = null;
  const RepositoryResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;
}

class ActivityRepository {
  final DatabaseHelper _db;
  ActivityRepository({DatabaseHelper? databaseHelper})
      : _db = databaseHelper ?? DatabaseHelper.instance;

  Future<RepositoryResult<List<Activity>>> getAllActivities() async {
    try {
      final activities = await _db.getAllActivities();
      return RepositoryResult.success(activities);
    } catch (e, st) {
      developer.log('getAllActivities failed', error: e, stackTrace: st);
      return const RepositoryResult.failure(
        'Could not load your activities. Please try again.',
      );
    }
  }

  Future<RepositoryResult<int>> addActivity(Activity activity) async {
    try {
      final id = await _db.insertActivity(activity);
      return RepositoryResult.success(id);
    } catch (e, st) {
      developer.log('addActivity failed', error: e, stackTrace: st);
      return const RepositoryResult.failure(
        'Could not save this activity. Please try again.',
      );
    }
  }

  Future<RepositoryResult<bool>> updateActivity(Activity activity) async {
    try {
      final rows = await _db.updateActivity(activity);
      if (rows == 0) {
        return const RepositoryResult.failure(
          'This activity no longer exists.',
        );
      }
      return const RepositoryResult.success(true);
    } catch (e, st) {
      developer.log('updateActivity failed', error: e, stackTrace: st);
      return const RepositoryResult.failure(
        'Could not update this activity. Please try again.',
      );
    }
  }

  Future<RepositoryResult<bool>> deleteActivity(int id) async {
    try {
      final rows = await _db.deleteActivity(id);
      if (rows == 0) {
        return const RepositoryResult.failure(
          'This activity was already removed.',
        );
      }
      return const RepositoryResult.success(true);
    } catch (e, st) {
      developer.log('deleteActivity failed', error: e, stackTrace: st);
      return const RepositoryResult.failure(
        'Could not delete this activity. Please try again.',
      );
    }
  }

  Future<RepositoryResult<Map<String, int>>> getGoals() async {
    try {
      final goals = await _db.getGoals();
      return RepositoryResult.success(goals);
    } catch (e, st) {
      developer.log('getGoals failed', error: e, stackTrace: st);
      return const RepositoryResult.failure('Could not load your goals.');
    }
  }

  Future<RepositoryResult<bool>> updateGoals({
    required int steps,
    required int calories,
    required int durationMinutes,
    required int workouts,
  }) async {
    try {
      await _db.updateGoals(
        steps: steps,
        calories: calories,
        durationMinutes: durationMinutes,
        workouts: workouts,
      );
      return const RepositoryResult.success(true);
    } catch (e, st) {
      developer.log('updateGoals failed', error: e, stackTrace: st);
      return const RepositoryResult.failure('Could not save your goals.');
    }
  }
}
