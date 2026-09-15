import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/activity.dart';
import '../../core/constants/app_constants.dart';

/// this class rather than opening its own connection
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'fitness_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        calories_burned INTEGER NOT NULL,
        steps INTEGER NOT NULL DEFAULT 0,
        date_time TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE goals (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        workouts INTEGER NOT NULL
      )
    ''');

    // "no goals set yet" anywhere in the UI.
    await db.insert('goals', {
      'id': 1,
      'steps': DefaultGoals.steps,
      'calories': DefaultGoals.calories,
      'duration_minutes': DefaultGoals.durationMinutes,
      'workouts': DefaultGoals.workouts,
    });
  }

  // ---- Activities ----

  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return db.insert('activities', activity.toMap());
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;
    return db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    final rows = await db.query('activities', orderBy: 'date_time DESC');
    return rows.map(Activity.fromMap).toList();
  }

  // ---- Goals ----

  Future<Map<String, int>> getGoals() async {
    final db = await database;
    final rows = await db.query('goals', where: 'id = 1', limit: 1);
    if (rows.isEmpty) {
      return {
        'steps': DefaultGoals.steps,
        'calories': DefaultGoals.calories,
        'duration_minutes': DefaultGoals.durationMinutes,
        'workouts': DefaultGoals.workouts,
      };
    }
    final row = rows.first;
    return {
      'steps': row['steps'] as int,
      'calories': row['calories'] as int,
      'duration_minutes': row['duration_minutes'] as int,
      'workouts': row['workouts'] as int,
    };
  }

  Future<void> updateGoals({
    required int steps,
    required int calories,
    required int durationMinutes,
    required int workouts,
  }) async {
    final db = await database;
    await db.update(
      'goals',
      {
        'steps': steps,
        'calories': calories,
        'duration_minutes': durationMinutes,
        'workouts': workouts,
      },
      where: 'id = 1',
    );
  }
}
