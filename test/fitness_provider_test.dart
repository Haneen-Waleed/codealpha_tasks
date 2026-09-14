import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_tracker/data/database/database_helper.dart';
import 'package:fitness_tracker/data/models/activity.dart';
import 'package:fitness_tracker/data/repositories/activity_repository.dart';
import 'package:fitness_tracker/state/fitness_provider.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dbPath = await databaseFactory.getDatabasesPath();
    await databaseFactory.deleteDatabase('$dbPath/fitness_tracker.db');
  });

  test('empty database produces an empty-but-valid loaded state', () async {
    final provider = FitnessProvider(
      repository: ActivityRepository(databaseHelper: DatabaseHelper.instance),
    );
    await provider.initialize();

    expect(provider.status, LoadStatus.loaded);
    expect(provider.activities, isEmpty);
    expect(provider.todaySteps, 0);
    expect(provider.todayCalories, 0);
    expect(provider.overallDailyProgress, 0);
  });

  test('Flow 3: adding an activity updates today\'s dashboard totals', () async {
    final provider = FitnessProvider(
      repository: ActivityRepository(databaseHelper: DatabaseHelper.instance),
    );
    await provider.initialize();

    final success = await provider.addActivity(
      Activity(
        type: 'Running',
        durationMinutes: 30,
        caloriesBurned: 300,
        steps: 5000,
        dateTime: DateTime.now(),
      ),
    );

    expect(success, isTrue);
    expect(provider.todaySteps, greaterThanOrEqualTo(5000));
    expect(provider.todayCalories, greaterThanOrEqualTo(300));
    expect(provider.todayWorkoutCount, greaterThanOrEqualTo(1));
    expect(provider.overallDailyProgress, greaterThan(0));
  });

  test('Flow 7: weekly totals correctly aggregate activities across days', () async {
    final provider = FitnessProvider(
      repository: ActivityRepository(databaseHelper: DatabaseHelper.instance),
    );
    await provider.initialize();

    final now = DateTime.now();
    final threeDaysAgo = now.subtract(const Duration(days: 3));

    await provider.addActivity(
      Activity(
        type: 'Walking',
        durationMinutes: 20,
        caloriesBurned: 100,
        steps: 3000,
        dateTime: threeDaysAgo,
      ),
    );

    final weekly = provider.weeklyTotals;
    expect(weekly.length, 7);

    final matchingDay = weekly.firstWhere(
      (d) =>
          d.date.year == threeDaysAgo.year &&
          d.date.month == threeDaysAgo.month &&
          d.date.day == threeDaysAgo.day,
    );
    expect(matchingDay.steps, greaterThanOrEqualTo(3000));
    expect(matchingDay.calories, greaterThanOrEqualTo(100));
  });

  test('an activity older than 7 days does not appear in weeklyTotals', () async {
    final provider = FitnessProvider(
      repository: ActivityRepository(databaseHelper: DatabaseHelper.instance),
    );
    await provider.initialize();

    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    await provider.addActivity(
      Activity(
        type: 'Yoga',
        durationMinutes: 20,
        caloriesBurned: 999,
        dateTime: tenDaysAgo,
      ),
    );

    final weeklyCaloriesFromOldActivity = provider.weeklyTotals
        .where((d) =>
            d.date.year == tenDaysAgo.year &&
            d.date.month == tenDaysAgo.month &&
            d.date.day == tenDaysAgo.day)
        .toList();
    // The 10-day-old activity should not land in any of the last 7 days.
    expect(weeklyCaloriesFromOldActivity, isEmpty);
  });
}
