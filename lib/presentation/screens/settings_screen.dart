import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/restart_widget.dart';
import '../../core/theme/theme_provider.dart';
import '../../state/fitness_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _steps;
  late TextEditingController _calories;
  late TextEditingController _duration;
  late TextEditingController _workouts;
  bool _initialized = false;
  bool _isSaving = false;

  String? _positiveIntValidator(String? value, {int max = 1000000}) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Enter a whole number';
    if (parsed <= 0) return 'Must be greater than 0';
    if (parsed > max) return 'That looks too high';
    return null;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.card,
      labelStyle:  TextStyle(color: AppColors.textSecondary),
      hintStyle:  TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:  BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:  BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.neon),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();

    if (!_initialized) {
      _steps = TextEditingController(text: provider.goalSteps.toString());
      _calories = TextEditingController(text: provider.goalCalories.toString());
      _duration = TextEditingController(text: provider.goalDurationMinutes.toString());
      _workouts = TextEditingController(text: provider.goalWorkouts.toString());
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Text(
                'Daily Goals',
                style: AppTextStyles.title.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'These goals power the progress ring and stats on your dashboard.',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),

              Text(
                'Steps',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _steps,
                style:  TextStyle(color: AppColors.white),
                decoration: _inputDecoration(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 200000),
              ),
              const SizedBox(height: 16),

              Text(
                'Calories',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _calories,
                style:  TextStyle(color: AppColors.white),
                decoration: _inputDecoration(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 10000),
              ),
              const SizedBox(height: 16),

              Text(
                'Workout duration (minutes)',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _duration,
                style:  TextStyle(color: AppColors.white),
                decoration: _inputDecoration(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 1440),
              ),
              const SizedBox(height: 16),

              Text(
                'Number of workouts',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _workouts,
                style:  TextStyle(color: AppColors.white),
                decoration: _inputDecoration(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 50),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.bg,
                  padding:  EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSaving
                    ? null
                    : () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _isSaving = true);
                  final success = await provider.updateGoals(
                    steps: int.parse(_steps.text.trim()),
                    calories: int.parse(_calories.text.trim()),
                    durationMinutes: int.parse(_duration.text.trim()),
                    workouts: int.parse(_workouts.text.trim()),
                  );
                  final feedback = provider.consumeFeedback();
                  if (!mounted) return;
                  setState(() => _isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.card,
                      content: Text(
                        feedback ??
                            (success
                                ? 'Goals updated.'
                                : 'Could not save goals.'),
                        style:  TextStyle(color: AppColors.white),
                      ),
                    ),
                  );
                },
                child: _isSaving
                    ?  SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.bg,
                  ),
                )
                    : const Text(
                  'Save Goals',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
// Place this inside SettingsScreen ListView children:

              const SizedBox(height: 24),
               Divider(color: AppColors.border),
              const SizedBox(height: 12),

              Text('Appearance', style: AppTextStyles.title),
              const SizedBox(height: 8),

              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Dark Mode',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Switch between light and dark visual style',
                      style: AppTextStyles.bodyMuted,
                    ),
                    value: themeProvider.isDarkMode,
                    activeColor: AppColors.neon,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                      RestartWidget.restartApp(context);
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
               Divider(color: AppColors.border),
              const SizedBox(height: 12),
              Text(
                'About',
                style: AppTextStyles.title.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Fitness Tracker stores all of your activity data locally on this '
                    'device. Nothing is uploaded or shared.',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}