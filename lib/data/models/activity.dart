class Activity {
  final int? id;
  final String type;
  final int durationMinutes;
  final int caloriesBurned;
  final int steps;
  final DateTime dateTime;
  final String? notes;

  const Activity({
    this.id,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.steps = 0,
    required this.dateTime,
    this.notes,
  });

  Activity copyWith({
    int? id,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    int? steps,
    DateTime? dateTime,
    String? notes,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'steps': steps,
      'date_time': dateTime.toIso8601String(),
      'notes': notes,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int?,
      type: map['type'] as String,
      durationMinutes: map['duration_minutes'] as int,
      caloriesBurned: map['calories_burned'] as int,
      steps: (map['steps'] as int?) ?? 0,
      dateTime: DateTime.parse(map['date_time'] as String),
      notes: map['notes'] as String?,
    );
  }
}
class ActivityValidator {
  ActivityValidator._();

  static String? validateType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Select a workout type';
    }
    return null;
  }

  static String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a duration';
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Duration must be a whole number';
    }
    if (parsed <= 0) {
      return 'Duration must be greater than 0';
    }
    if (parsed > 1440) {
      return 'Duration can\'t exceed 24 hours';
    }
    return null;
  }

  static String? validateCalories(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter calories burned';
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Calories must be a whole number';
    }
    if (parsed < 0) {
      return 'Calories can\'t be negative';
    }
    if (parsed > 10000) {
      return 'That looks too high — check the value';
    }
    return null;
  }

  static String? validateSteps(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Steps must be a whole number';
    }
    if (parsed < 0) {
      return 'Steps can\'t be negative';
    }
    if (parsed > 200000) {
      return 'That looks too high — check the value';
    }
    return null;
  }
}
