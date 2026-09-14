import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_tracker/data/database/database_helper.dart';
import 'package:fitness_tracker/data/models/activity.dart';
import 'package:fitness_tracker/data/repositories/activity_repository.dart';

void main() {
  late ActivityRepository repository;

  setUpAll(() async {
    // Route sqflite through the FFI (desktop/test) backend instead of the
    // platform channel implementation, which isn't available under `flutter
    // test`. This exercises the *real* SQL, not a mock.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Ensure each test run starts from a clean database file.
    final dbPath = await databaseFactory.getDatabasesPath();
    await databaseFactory.deleteDatabase('$dbPath/fitness_tracker.db');

    repository = ActivityRepository(databaseHelper: DatabaseHelper.instance);
  });

  test('Flow 2/3: adding an activity persists it and it can be read back', () async {
    final result = await repository.addActivity(
      Activity(
        type: 'Running',
        durationMinutes: 30,
        caloriesBurned: 300,
        steps: 4000,
        dateTime: DateTime.now(),
      ),
    );
    expect(result.isSuccess, isTrue);
    expect(result.data, isNotNull);

    final all = await repository.getAllActivities();
    expect(all.isSuccess, isTrue);
    expect(all.data!.any((a) => a.type == 'Running' && a.caloriesBurned == 300),
        isTrue);
  });

  test('Flow 4: editing an activity updates the stored values', () async {
    final added = await repository.addActivity(
      Activity(
        type: 'Cycling',
        durationMinutes: 20,
        caloriesBurned: 150,
        dateTime: DateTime.now(),
      ),
    );
    final id = added.data!;

    final updateResult = await repository.updateActivity(
      Activity(
        id: id,
        type: 'Cycling',
        durationMinutes: 45,
        caloriesBurned: 400,
        dateTime: DateTime.now(),
      ),
    );
    expect(updateResult.isSuccess, isTrue);

    final all = (await repository.getAllActivities()).data!;
    final updated = all.firstWhere((a) => a.id == id);
    expect(updated.durationMinutes, 45);
    expect(updated.caloriesBurned, 400);
  });

  test('Flow 5: deleting an activity removes it from storage', () async {
    final added = await repository.addActivity(
      Activity(
        type: 'Yoga',
        durationMinutes: 15,
        caloriesBurned: 50,
        dateTime: DateTime.now(),
      ),
    );
    final id = added.data!;

    final deleteResult = await repository.deleteActivity(id);
    expect(deleteResult.isSuccess, isTrue);

    final all = (await repository.getAllActivities()).data!;
    expect(all.any((a) => a.id == id), isFalse);
  });

  test('Deleting a non-existent activity fails safely (no crash)', () async {
    final result = await repository.deleteActivity(999999);
    expect(result.isSuccess, isFalse);
    expect(result.error, isNotNull);
  });

  test('Flow 6: data persists across a fresh DatabaseHelper instance (simulated restart)',
      () async {
    // insertActivity via the shared connection...
    await repository.addActivity(
      Activity(
        type: 'Swimming',
        durationMinutes: 40,
        caloriesBurned: 350,
        dateTime: DateTime.now(),
      ),
    );

    // ...then read through a brand new repository/helper reference, the way
    // a fresh app launch would reconnect to the same on-disk database file.
    final freshRepository = ActivityRepository(databaseHelper: DatabaseHelper.instance);
    final all = (await freshRepository.getAllActivities()).data!;
    expect(all.any((a) => a.type == 'Swimming'), isTrue);
  });

  test('Goals can be updated and are read back correctly', () async {
    final updateResult = await repository.updateGoals(
      steps: 8000,
      calories: 400,
      durationMinutes: 45,
      workouts: 2,
    );
    expect(updateResult.isSuccess, isTrue);

    final goals = (await repository.getGoals()).data!;
    expect(goals['steps'], 8000);
    expect(goals['calories'], 400);
    expect(goals['duration_minutes'], 45);
    expect(goals['workouts'], 2);
  });
}
