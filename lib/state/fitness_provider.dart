import 'package:flutter/foundation.dart';
import '../data/models/activity.dart';
import '../data/repositories/activity_repository.dart';

enum LoadStatus { loading, loaded, error }

class FitnessProvider extends ChangeNotifier {
  final ActivityRepository _repository;

  FitnessProvider({ActivityRepository? repository})
      : _repository = repository ?? ActivityRepository();

  LoadStatus _status = LoadStatus.loading;
  LoadStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Activity> _activities = [];
  List<Activity> get activities => List.unmodifiable(_activities);

  int _goalSteps = 10000;
  int _goalCalories = 500;
  int _goalDurationMinutes = 60;
  int _goalWorkouts = 1;

  int get goalSteps => _goalSteps;
  int get goalCalories => _goalCalories;
  int get goalDurationMinutes => _goalDurationMinutes;
  int get goalWorkouts => _goalWorkouts;

  String? _feedback;
  String? consumeFeedback() {
    final msg = _feedback;
    _feedback = null;
    return msg;
  }

  Future<void> initialize() async {
    _status = LoadStatus.loading;
    notifyListeners();

    final goalsResult = await _repository.getGoals();
    if (goalsResult.isSuccess && goalsResult.data != null) {
      _goalSteps = goalsResult.data!['steps']!;
      _goalCalories = goalsResult.data!['calories']!;
      _goalDurationMinutes = goalsResult.data!['duration_minutes']!;
      _goalWorkouts = goalsResult.data!['workouts']!;
    }

    final activitiesResult = await _repository.getAllActivities();
    if (activitiesResult.isSuccess && activitiesResult.data != null) {
      _activities = activitiesResult.data!;
      _status = LoadStatus.loaded;
    } else {
      _status = LoadStatus.error;
      _errorMessage = activitiesResult.error;
    }
    notifyListeners();
  }

  Future<bool> addActivity(Activity activity) async {
    final result = await _repository.addActivity(activity);
    if (!result.isSuccess) {
      _feedback = result.error;
      notifyListeners();
      return false;
    }
    final saved = activity.copyWith(id: result.data);
    _activities = [saved, ..._activities]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    _feedback = 'Activity saved.';
    notifyListeners();
    return true;
  }

  Future<bool> editActivity(Activity activity) async {
    final result = await _repository.updateActivity(activity);
    if (!result.isSuccess) {
      _feedback = result.error;
      notifyListeners();
      return false;
    }
    _activities = _activities
        .map((a) => a.id == activity.id ? activity : a)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    _feedback = 'Activity updated.';
    notifyListeners();
    return true;
  }

  Future<bool> removeActivity(int id) async {
    final result = await _repository.deleteActivity(id);
    if (!result.isSuccess) {
      _feedback = result.error;
      notifyListeners();
      return false;
    }
    _activities = _activities.where((a) => a.id != id).toList();
    _feedback = 'Activity deleted.';
    notifyListeners();
    return true;
  }

  Future<bool> updateGoals({
    required int steps,
    required int calories,
    required int durationMinutes,
    required int workouts,
  }) async {
    final result = await _repository.updateGoals(
      steps: steps,
      calories: calories,
      durationMinutes: durationMinutes,
      workouts: workouts,
    );
    if (!result.isSuccess) {
      _feedback = result.error;
      notifyListeners();
      return false;
    }
    _goalSteps = steps;
    _goalCalories = calories;
    _goalDurationMinutes = durationMinutes;
    _goalWorkouts = workouts;
    _feedback = 'Goals updated.';
    notifyListeners();
    return true;
  }


  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Activity> get todayActivities {
    final now = DateTime.now();
    return _activities.where((a) => _isSameDay(a.dateTime, now)).toList();
  }

  int get todaySteps =>
      todayActivities.fold(0, (sum, a) => sum + a.steps);

  int get todayCalories =>
      todayActivities.fold(0, (sum, a) => sum + a.caloriesBurned);

  int get todayDurationMinutes =>
      todayActivities.fold(0, (sum, a) => sum + a.durationMinutes);

  int get todayWorkoutCount => todayActivities.length;

  double get stepsProgress =>
      _goalSteps == 0 ? 0 : (todaySteps / _goalSteps).clamp(0, 1).toDouble();

  double get caloriesProgress => _goalCalories == 0
      ? 0
      : (todayCalories / _goalCalories).clamp(0, 1).toDouble();

  double get durationProgress => _goalDurationMinutes == 0
      ? 0
      : (todayDurationMinutes / _goalDurationMinutes).clamp(0, 1).toDouble();

  double get workoutsProgress => _goalWorkouts == 0
      ? 0
      : (todayWorkoutCount / _goalWorkouts).clamp(0, 1).toDouble();

  double get overallDailyProgress {
    final values = [
      stepsProgress,
      caloriesProgress,
      durationProgress,
      workoutsProgress,
    ];
    return values.reduce((a, b) => a + b) / values.length;
  }

  List<Activity> get recentActivities {
    final sorted = [..._activities]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sorted.take(5).toList();
  }

  List<DailyTotal> get weeklyTotals {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<DailyTotal> days = [];

    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final dayActivities =
          _activities.where((a) => _isSameDay(a.dateTime, day)).toList();
      days.add(
        DailyTotal(
          date: day,
          steps: dayActivities.fold(0, (sum, a) => sum + a.steps),
          calories: dayActivities.fold(0, (sum, a) => sum + a.caloriesBurned),
          durationMinutes:
              dayActivities.fold(0, (sum, a) => sum + a.durationMinutes),
          workouts: dayActivities.length,
        ),
      );
    }
    return days;
  }

  int get weeklyTotalSteps =>
      weeklyTotals.fold(0, (sum, d) => sum + d.steps);
  int get weeklyTotalCalories =>
      weeklyTotals.fold(0, (sum, d) => sum + d.calories);
  int get weeklyTotalWorkouts =>
      weeklyTotals.fold(0, (sum, d) => sum + d.workouts);
  int get weeklyTotalDuration =>
      weeklyTotals.fold(0, (sum, d) => sum + d.durationMinutes);
}

class DailyTotal {
  final DateTime date;
  final int steps;
  final int calories;
  final int durationMinutes;
  final int workouts;

  const DailyTotal({
    required this.date,
    required this.steps,
    required this.calories,
    required this.durationMinutes,
    required this.workouts,
  });
}
