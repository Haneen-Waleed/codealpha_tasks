import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/activity.dart';
import '../../state/fitness_provider.dart';

/// Handles both creating a new activity and editing an existing one.
/// Pass `existingActivity` to switch the screen into edit mode.
class AddEditActivityScreen extends StatefulWidget {
  final Activity? existingActivity;

  const AddEditActivityScreen({super.key, this.existingActivity});

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedType;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  late TextEditingController _stepsController;
  late TextEditingController _notesController;
  late DateTime _selectedDateTime;

  bool _isSaving = false;

  bool get _isEditing => widget.existingActivity != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingActivity;
    _selectedType = existing?.type ?? WorkoutTypes.all.first;
    _durationController =
        TextEditingController(text: existing?.durationMinutes.toString() ?? '');
    _caloriesController =
        TextEditingController(text: existing?.caloriesBurned.toString() ?? '');
    _stepsController = TextEditingController(
      text: existing != null && existing.steps > 0 ? existing.steps.toString() : '',
    );
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _selectedDateTime = existing?.dateTime ?? DateTime.now();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final activity = Activity(
      id: widget.existingActivity?.id,
      type: _selectedType,
      durationMinutes: int.parse(_durationController.text.trim()),
      caloriesBurned: int.parse(_caloriesController.text.trim()),
      steps: _stepsController.text.trim().isEmpty
          ? 0
          : int.parse(_stepsController.text.trim()),
      dateTime: _selectedDateTime,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final provider = context.read<FitnessProvider>();
    final success = _isEditing
        ? await provider.editActivity(activity)
        : await provider.addActivity(activity);

    if (!mounted) return;
    setState(() => _isSaving = false);

    final feedback = provider.consumeFeedback();
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(feedback ?? 'Saved.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(feedback ?? 'Could not save. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showSteps = WorkoutTypes.stepRelevant.contains(_selectedType) ||
        _stepsController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Activity' : 'Add Activity'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const Text('Workout type', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: WorkoutTypes.all
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedType = value);
                },
                validator: (value) => ActivityValidator.validateType(value),
              ),
              const SizedBox(height: 18),

              const Text('Duration (minutes)', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'e.g. 30'),
                validator: ActivityValidator.validateDuration,
              ),
              const SizedBox(height: 18),

              const Text('Calories burned', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'e.g. 250'),
                validator: ActivityValidator.validateCalories,
              ),
              const SizedBox(height: 18),

              if (showSteps) ...[
                const Text('Steps (optional)', style: AppTextStyles.bodyMuted),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _stepsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(hintText: 'e.g. 4000'),
                  validator: ActivityValidator.validateSteps,
                ),
                const SizedBox(height: 18),
              ],

              const Text('Date & time', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppColors.deepTeal),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('EEE, MMM d, yyyy · h:mm a')
                            .format(_selectedDateTime),
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Text('Notes (optional)', style: AppTextStyles.bodyMuted),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: 'Anything worth remembering about this session',
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.surfaceWhite,
                        ),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Save Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
