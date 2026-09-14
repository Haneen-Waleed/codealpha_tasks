import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/db/ffi_initializer.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/main_navigation.dart';
import 'state/fitness_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ROOT CAUSE FIX: the `sqflite` plugin only auto-registers a
  // `databaseFactory` on Android and iOS via native platform channels. On
  // desktop nothing registers one, so every DB call throws "Bad state:
  // databaseFactory not initialized". `initializeDesktopDatabaseFactoryIfNeeded()`
  // (in core/db/ffi_initializer.dart) fixes that on desktop and is a no-op
  // everywhere else. It's split into a separate file with a conditional
  // import specifically so the web build never has to import
  // `sqflite_common_ffi` at all — that package depends on `dart:ffi`, which,
  // like `dart:io`, cannot be compiled for web.
  initializeDesktopDatabaseFactoryIfNeeded();

  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This app persists data with `sqflite`, which has no web
    // implementation. Running it in a browser (e.g. `flutter run -d
    // chrome`) will fail on every database call. Fail loudly and clearly
    // here instead of letting the cryptic "databaseFactory not
    // initialized" error surface from three different places.
    if (kIsWeb) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _UnsupportedPlatformScreen(),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => FitnessProvider()..initialize(),
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainNavigation(),
      ),
    );
  }
}

class _UnsupportedPlatformScreen extends StatelessWidget {
  const _UnsupportedPlatformScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.phonelink_off, size: 40, color: AppColors.midGray),
                SizedBox(height: 16),
                Text(
                  'This app needs a mobile or desktop target',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Fitness Tracker stores data with local SQLite, which the '
                  'web platform does not support. Please run this app on an '
                  'Android/iOS emulator, a physical device, or as a desktop '
                  'app instead of a browser.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
