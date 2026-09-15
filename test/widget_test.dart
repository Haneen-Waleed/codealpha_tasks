import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_tracker/core/theme/app_theme.dart';
import 'package:fitness_tracker/data/database/database_helper.dart';
import 'package:fitness_tracker/data/repositories/activity_repository.dart';
import 'package:fitness_tracker/presentation/screens/main_navigation.dart';
import 'package:fitness_tracker/state/fitness_provider.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dbPath = await databaseFactory.getDatabasesPath();
    await databaseFactory.deleteDatabase('$dbPath/fitness_tracker.db');
  });

  Widget buildTestApp() {
    return ChangeNotifierProvider(
      create: (_) => FitnessProvider(
        repository: ActivityRepository(databaseHelper: DatabaseHelper.instance),
      )..initialize(),
      child: MaterialApp(
        theme: AppTheme.dark,
        home: const MainNavigation(),
      ),
    );
  }

  testWidgets('Flow 1 & 9: dashboard loads and shows the empty state on a fresh DB',
      (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Nothing recorded yet'), findsOneWidget);
    expect(find.text('Add Activity'), findsOneWidget);
  });

  testWidgets('Flow 10: bottom navigation switches between all four screens',
      (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsWidgets);

    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('No progress yet'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Goals'), findsOneWidget);
  });

  testWidgets('Flow 8: submitting the Add Activity form with empty fields shows validation errors',
      (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Activity'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Activity'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a duration'), findsOneWidget);
    expect(find.text('Enter calories burned'), findsOneWidget);
  });
}
