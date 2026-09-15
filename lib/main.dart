import 'package:fitness_tracker/presentation/screens/splash_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/db/ffi_initializer.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/restart_widget.dart';
import 'core/theme/theme_provider.dart';
import 'state/fitness_provider.dart';

// main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDesktopDatabaseFactoryIfNeeded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FitnessProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // <-- Above FitnessTrackerApp
      ],
      child: RestartWidget(child: const FitnessTrackerApp()),
    ),
  );
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _UnsupportedPlatformScreen(),
      );
    }

    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

class _UnsupportedPlatformScreen extends StatelessWidget {
  const _UnsupportedPlatformScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phonelink_off, size: 40, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text(
                  'This app needs a mobile or desktop target',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fitness Tracker stores data with local SQLite, which the '
                      'web platform does not support. Please run this app on an '
                      'Android/iOS emulator, a physical device, or as a desktop '
                      'app instead of a browser.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}