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
  static const List<String> stepRelevant = ['Running', 'Walking'];
}
class DefaultGoals {
  DefaultGoals._();

  static const int steps = 10000;
  static const int calories = 500;
  static const int durationMinutes = 60;
  static const int workouts = 1;
}
