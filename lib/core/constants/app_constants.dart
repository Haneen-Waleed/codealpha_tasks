/// Fixed list of workout types offered in the "Add Activity" dropdown.
/// Keeping this closed (rather than free text) is what makes stats like
/// "most frequent workout" meaningful instead of a mess of typos.
class WorkoutTypes {
  WorkoutTypes._();

  static const List<String> all = [
    'Running',
    'Walking',
    'Cycling',
    'Strength Training',
    'Yoga',
    'Swimming',
    'HIIT',
    'Other',
  ];

  /// Types where logging steps makes sense; used to decide whether to show
  /// the steps field in the Add Activity form.
  static const List<String> stepRelevant = ['Running', 'Walking'];
}

/// Default daily goals used the first time the app runs. After that, the
/// user's saved goals (from the `goals` table) always take precedence.
class DefaultGoals {
  DefaultGoals._();

  static const int steps = 10000;
  static const int calories = 500;
  static const int durationMinutes = 60;
  static const int workouts = 1;
}
