import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              const Text('Daily Goals', style: AppTextStyles.title),
              const SizedBox(height: 4),
              const Text(
                'These goals power the progress ring and stats on your dashboard.',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 20),

              const Text('Steps', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _steps,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 200000),
              ),
              const SizedBox(height: 16),

              const Text('Calories', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _calories,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 10000),
              ),
              const SizedBox(height: 16),

              const Text('Workout duration (minutes)', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 1440),
              ),
              const SizedBox(height: 16),

              const Text('Number of workouts', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _workouts,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveIntValidator(v, max: 50),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
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
                            content: Text(
                              feedback ??
                                  (success ? 'Goals updated.' : 'Could not save goals.'),
                            ),
                          ),
                        );
                      },
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.surfaceWhite,
                        ),
                      )
                    : const Text('Save Goals'),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 12),
              const Text('About', style: AppTextStyles.title),
              const SizedBox(height: 8),
              const Text(
                'Fitness Tracker stores all of your activity data locally on this '
                'device. Nothing is uploaded or shared.',
                style: AppTextStyles.bodyMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
